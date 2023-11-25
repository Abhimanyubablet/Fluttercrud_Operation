import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? _user;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  Future getImageGallery() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  Future<void> _updateUserProfile() async {
    if (_user != null) {
      try {
        await _user!.updatePhotoURL(_image!.path);
        await _user!.updateEmail("newemail@example.com"); // Replace with the new email
        await _user!.updateDisplayName("New Display Name"); // Replace with the new display name

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated successfully!"),
          ),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile"),
          ),
        );
      }
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    if (_image != null) {
      try {
        final storage = FirebaseStorage.instance;
        final Reference storageReference =
        storage.ref().child("user_images/${_user!.uid}");
        await storageReference.putFile(_image!);
        String imageUrl = await storageReference.getDownloadURL();

        // Now you have the download URL of the uploaded image (imageUrl)
        print("Image uploaded to Firebase Storage: $imageUrl");
      } catch (e) {
        print("Error uploading image to Firebase Storage: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null && _user!.photoURL != null)
              Center(
                child: InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _image != null
                            ? FileImage(_image!) as ImageProvider<Object>
                            : NetworkImage(_user!.photoURL!) as ImageProvider<Object>,
                      ),
                    ),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(child: Icon(Icons.image)),
                  ),
                ),
              ),
            if (_user != null && _user!.email != null)
              Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (newEmail) {
                    // Handle the new email change
                  },
                  decoration: InputDecoration(
                    hintText: _user!.email!,
                  ),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await _updateUserProfile();
                  await _uploadImageToFirebaseStorage();

                  Navigator.pushNamed(context, "dashboard");
                },
                child: Text("Save Changes"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
