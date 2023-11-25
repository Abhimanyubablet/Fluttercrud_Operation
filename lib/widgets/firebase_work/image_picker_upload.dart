import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUpload extends StatefulWidget {
  const ImagePickerUpload({super.key});

  @override
  State<ImagePickerUpload> createState() => _ImagePickerUploadState();
}

class _ImagePickerUploadState extends State<ImagePickerUpload> {
  var userNameStoreController = TextEditingController();
  var userEmailStoreController = TextEditingController();
  var userContactStoreController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  var storage = FirebaseStorage.instance;

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  Future<void> uploadImage() async {
    if (_image != null) {
      try {
        File file = File(_image!.path);
        // Upload image to Firebase Storage
        var  storageRef = storage.ref();
        var uploadTask = storageRef.child("/image").child("Data").putFile(file);

        // Wait for the upload to complete
        await uploadTask;

        // Get the download URL
        var imageUrl = await storageRef.getDownloadURL();

        // Get user input from text fields
        String userName = userNameStoreController.text;
        String userEmail = userEmailStoreController.text;
        String userContact = userContactStoreController.text;

        // Add the image URL to Firestore
        await FirebaseFirestore.instance.collection('usersData').add({
          'imageUrl': imageUrl,
          'name': userName,
          'email': userEmail,
          'contact': userContact,
          'timestamp': FieldValue.serverTimestamp(), // Add a timestamp if needed
        });

        toastMessage('Image uploaded successfully.');
      } catch (error) {
        toastMessage('Error uploading image: $error');
      }
    } else {
      toastMessage('Please pick an image first.');
    }
  }

  void toastMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Upload In Firebase"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: _image != null ? Image.file(_image!.absolute) : Center(child: Icon(Icons.image)),
                ),
              ),
            ),

            Container(
                margin: EdgeInsets.all(15),
              child: TextField(
                  controller: userNameStoreController,
                decoration: InputDecoration(
                  hintText: "Name",
              )
            )
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                    controller: userEmailStoreController,
                    decoration: InputDecoration(
                      hintText: "Email",
                    )
                )
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                    controller: userContactStoreController,
                    decoration: InputDecoration(
                      hintText: "Contact",

                    )
                )
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: uploadImage,
                child: Text("Upload"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
