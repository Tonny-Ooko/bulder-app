import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  String? profilePicUrl;
  List<String> workPhotos = [];
  bool showSuccessMessage = false;
  bool isConstructionWorker = false;
  List<String> skills = [];
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  // Save profile function
  Future<void> _saveProfile() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        _showSnackBar('No authenticated user found.');
        return;
      }

      bool isVerified = false;

      // Prepare data to save
      Map<String, dynamic> firestoreData = {
        'uid': user.uid,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'specialization': _specializationController.text,
        'experience': _experienceController.text,
        'profilePictureUrl': profilePicUrl ?? '',
        'workPhotos': workPhotos,
        'skills': skills,
        'isVerified': isVerified,
      };

      // Basic validation
      if (_nameController.text.isEmpty || _nameController.text.split(' ').length < 2) {
        _showSnackBar('Full Name must contain at least two names.');
        return;
      }

      if (_emailController.text.isEmpty) {
        _showSnackBar('Email is required.');
        return;
      }

      if (_phoneController.text.isEmpty) {
        _showSnackBar('Phone number is required.');
        return;
      }

      if (isConstructionWorker) {
        if (_specializationController.text.isEmpty) {
          _showSnackBar('Specialization is required for Construction Workers.');
          return;
        }
        if (skills.length < 4) {
          _showSnackBar('Construction Workers must provide at least four skills.');
          return;
        }
        if (workPhotos.length < 4) {
          _showSnackBar('Please upload at least 4 photos of your previous work.');
          return;
        }
      }

      // Save to Firestore
      await _firestore.collection('users').doc(user.uid).set(firestoreData, SetOptions(merge: true));

      setState(() {
        showSuccessMessage = true;
      });

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          showSuccessMessage = false;
        });
      });
    } catch (e) {
      _showSnackBar('Failed to save profile. Please try again. Error: $e');
    }
  }

  // Upload profile picture
  Future<void> _uploadProfilePicture() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${_auth.currentUser?.uid}');
        await storageRef.putFile(file);
        String downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          profilePicUrl = downloadUrl;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to upload profile picture. Error: $e');
    }
  }

  // Upload work photos
  Future<void> _uploadWorkPhotos() async {
    try {
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null) {
        if (pickedFiles.length < 4) {
          _showSnackBar('Please upload at least 4 photos of your previous work.');
          return;
        }

        for (var file in pickedFiles) {
          File imageFile = File(file.path);
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('work_photos/${_auth.currentUser?.uid}/${file.name}');
          await storageRef.putFile(imageFile);
          String downloadUrl = await storageRef.getDownloadURL();
          setState(() {
            workPhotos.add(downloadUrl);
          });
        }
      }
    } catch (e) {
      _showSnackBar('Failed to upload work photo. Error: $e');
    }
  }

  // Skill management
  void _addSkill(String skill) {
    if (skill.isNotEmpty && !skills.contains(skill)) {
      setState(() {
        skills.add(skill);
      });
    }
  }

  void _showAddSkillDialog() {
    final TextEditingController skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Skill'),
          content: TextField(
            controller: skillController,
            decoration: InputDecoration(labelText: 'Skill'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addSkill(skillController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Display message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
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
                    'Profile saved successfully!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              // Profile Picture Upload
              GestureDetector(
                onTap: _uploadProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
                  child: profilePicUrl == null
                      ? Icon(Icons.add, color: Colors.white, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Account Type Selection
              DropdownButtonFormField<bool>(
                value: isConstructionWorker,
                onChanged: (value) {
                  setState(() {
                    isConstructionWorker = value ?? false;
                    skills.clear(); // Reset skills if user switches to normal user
                  });
                },
                items: [
                  DropdownMenuItem(value: false, child: Text("Register as Normal User")),
                  DropdownMenuItem(value: true, child: Text("Register as Construction Worker")),
                ],
                decoration: InputDecoration(
                  labelText: "Select Account Type",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Specialization Field (only for Construction Workers)
              if (isConstructionWorker)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _specializationController,
                      decoration: InputDecoration(
                        labelText: "Specialization",
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Skills Section
                    Text("Skills:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      children: skills.map((skill) {
                        return Chip(label: Text(skill));
                      }).toList(),
                    ),
                    TextButton(
                      onPressed: _showAddSkillDialog,
                      child: Text("Add Skill"),
                    ),
                    const SizedBox(height: 20),

                    // Upload Work Photos
                    ElevatedButton(
                      onPressed: _uploadWorkPhotos,
                      child: Text("Upload Work Photos"),
                    ),
                  ],
                ),

              // Save Button
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
