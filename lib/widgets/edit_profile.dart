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
        if (_image != null) {
          // Upload the image to Firebase Storage
          await _uploadImageToFirebaseStorage();

          // Get the download URL of the uploaded image
          String imageUrl = await FirebaseStorage.instance
              .ref()
              .child("user_images/${_user!.uid}")
              .getDownloadURL();

          // Update user profile with the image URL
          await _user!.updatePhotoURL(imageUrl);
        }


        // Provide feedback to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated successfully!"),
          ),
        );

      } catch (e) {
        // Handle the error and provide feedback to the user
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile: $e"),
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

                    ),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(child: Image.network(
                      _user!.photoURL!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    ),
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
