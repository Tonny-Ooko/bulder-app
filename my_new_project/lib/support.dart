import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _issueController = TextEditingController();
  bool issueSubmitted = false;

  void _submitIssue() {
    if (_issueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please describe the issue before submitting.'),
      ));
      return;
    }
    setState(() {
      issueSubmitted = true;
    });
    // Logic to submit the issue or send an email
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Issue submitted successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report an Issue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _issueController,
              decoration: InputDecoration(
                labelText: 'Describe your issue',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitIssue,
              child: Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Yellow button
              ),
            ),
            if (issueSubmitted)
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(12),
                color: Colors.green,
                child: Text(
                  'Your issue has been submitted! We will get back to you shortly.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
