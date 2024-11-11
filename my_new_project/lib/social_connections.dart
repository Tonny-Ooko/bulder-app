import 'package:flutter/material.dart';

class SocialConnections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Social Connections')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Add functionality to sync contacts
            },
            child: Text('Sync Contacts'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add functionality to sync Facebook friends
            },
            child: Text('Sync Facebook Friends'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add functionality to share account link
            },
            child: Text('Share Account Link'),
          ),
        ],
      ),
    );
  }
}
