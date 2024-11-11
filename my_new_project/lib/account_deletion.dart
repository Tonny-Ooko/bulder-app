import 'package:flutter/material.dart';
import 'firebase_services.dart';

class AccountDeletionPage extends StatelessWidget {
  // Create an instance of FirebaseServices
  final FirebaseServices _firebaseServices = FirebaseServices();

  Future<void> _deleteAccount() async {
    await _firebaseServices.deleteAccount(); // Call deleteAccount on the instance
    // After deletion, navigate or log out
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Account')),
      body: Center(
        child: ElevatedButton(
          onPressed: _deleteAccount,
          child: Text('Delete My Account'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ),
    );
  }
}
