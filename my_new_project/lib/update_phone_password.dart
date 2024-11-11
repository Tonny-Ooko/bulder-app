import 'package:flutter/material.dart';
import 'firebase_services.dart';

class UpdatePhonePassword extends StatefulWidget {
  @override
  _UpdatePhonePasswordState createState() => _UpdatePhonePasswordState();
}

class _UpdatePhonePasswordState extends State<UpdatePhonePassword> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verificationIdController = TextEditingController();
  final _smsCodeController = TextEditingController();

  Future<void> _updateDetails() async {
    String phone = _phoneController.text;
    String verificationId = _verificationIdController.text; // Assuming you have a method to get the verification ID
    String smsCode = _smsCodeController.text; // Assuming you have the SMS code here
    String password = _passwordController.text;

    try {
      await FirebaseServices().updatePhoneAndPassword(phone, verificationId, smsCode, password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone and Password Updated!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Phone & Password')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _verificationIdController,
              decoration: InputDecoration(labelText: 'Verification ID'),
            ),
            TextField(
              controller: _smsCodeController,
              decoration: InputDecoration(labelText: 'SMS Code'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _updateDetails,
              child: Text('Update'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }
}
