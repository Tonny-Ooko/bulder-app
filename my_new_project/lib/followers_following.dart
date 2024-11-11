import 'package:flutter/material.dart';
import 'firebase_services.dart';

class FollowersFollowing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create an instance of FirebaseServices
    final FirebaseServices firebaseServices = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers & Following'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<String>>(
        future: firebaseServices.getFollowersFollowing(), // Call the method on the instance
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            final people = snapshot.data ?? [];

            if (people.isEmpty) {
              return const Center(
                child: Text(
                  "No followers or following yet",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[800],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      people[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
