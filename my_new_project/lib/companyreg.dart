import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'dart:io'; // Import File class from dart:io

class CompanyRegPage extends StatefulWidget {
  @override
  _CompanyRegPageState createState() => _CompanyRegPageState();
}

class _CompanyRegPageState extends State<CompanyRegPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Initialize Firebase Storage

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController(); // Website controller

  bool showSuccessMessage = false;

  // Image selection
  List<XFile>? _images; // Store multiple images
  final ImagePicker _picker = ImagePicker();

  // Method to pick images
  Future<void> _pickImages() async {
    final pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images = pickedImages;
      });
    }
  }

  // Method to save company details to Firestore
  Future<void> _saveCompanyDetails() async {
    final user = _auth.currentUser;

    // Data for Firestore
    Map<String, dynamic> companyData = {
      'uid': user!.uid,
      'companyName': _companyNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'location': _locationController.text,
      'services': _servicesController.text,
      'website': _websiteController.text,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      // Validate required fields
      if (_companyNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Company Name is required.'),
        ));
        return;
      }
      if (_emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email is required.'),
        ));
        return;
      }
      if (_phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Phone number is required.'),
        ));
        return;
      }
      if (_locationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Location is required.'),
        ));
        return;
      }
      if (_servicesController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Services are required.'),
        ));
        return;
      }
      if (_websiteController.text.isEmpty || !Uri.parse(_websiteController.text).isAbsolute) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a valid website URL.'),
        ));
        return;
      }

      // Save company details to Firestore
      await _firestore.collection('companies').doc(user.uid).set(companyData, SetOptions(merge: true));

      // Upload images to Firebase Storage if any images are selected
      if (_images != null && _images!.isNotEmpty) {
        for (var image in _images!) {
          final fileName = image.name; // Get file name
          final storageRef = _storage.ref().child('company_profiles/${user.uid}/$fileName'); // Create reference
          await storageRef.putFile(File(image.path)); // Ensure File is recognized
        }
      }

      // Make an API call to save the company data if needed
      final response = await http.post(
        Uri.parse('https://example.com/api/save_company'),
        body: companyData,
      );

      if (response.statusCode == 200) {
        // Navigate to home after saving successfully
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('Failed to save company details via API. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save company details. Please try again.'),
        ));
      }

      // Display success message for Firestore save
      setState(() {
        showSuccessMessage = true;
      });

      // Auto-hide the success message after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          showSuccessMessage = false;
        });
      });
    } catch (e) {
      print('Error saving company details: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save company details. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Registration'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (showSuccessMessage)
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.green,
                  child: Text(
                    'Company details saved successfully!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              // Company Name Field
              TextField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: "Company Name"),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
              const SizedBox(height: 20),

              // Location Field
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 20),

              // Services Offered Field
              TextField(
                controller: _servicesController,
                decoration: InputDecoration(labelText: "Services Offered"),
              ),
              const SizedBox(height: 20),

              // Website Field
              TextField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: "Website URL"),
              ),
              const SizedBox(height: 20),

              // Image Upload Button
              ElevatedButton(
                onPressed: _pickImages,
                child: Text("Upload Company Images"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Change button color to yellow
                ),
              ),
              const SizedBox(height: 20),

              // Save Company Button
              ElevatedButton(
                onPressed: _saveCompanyDetails,
                child: Text("Submit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Use yellow for submit button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
