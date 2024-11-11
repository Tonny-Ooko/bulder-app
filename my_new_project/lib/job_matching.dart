import 'package:flutter/material.dart';

class JobMatchingScreen extends StatelessWidget {
  const JobMatchingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Suppliers or Jobs'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Search for suppliers or jobs in the construction industry:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter job or supplier type',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add search functionality
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[900],
    );
  }
}
