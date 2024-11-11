import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Importing dart:io for the File class
import 'firebase_services.dart';

class UpdateProfileImage extends StatefulWidget {
  @override
  _UpdateProfileImageState createState() => _UpdateProfileImageState();
}

class _UpdateProfileImageState extends State<UpdateProfileImage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseServices _firebaseServices = FirebaseServices(); // Create an instance of FirebaseServices

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      await _firebaseServices.uploadProfileImage(_image!.path); // Use the instance to call the method
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile image updated successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select an image to upload.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile Image')),
      body: Column(
        children: [
          if (_image != null) Image.file(File(_image!.path)),
          ElevatedButton(onPressed: _pickImage, child: Text('Select Image')),
          ElevatedButton(
            onPressed: _uploadImage,
            child: Text('Upload Image'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
          ),
        ],
      ),
    );
  }
}
