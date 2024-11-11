import 'package:flutter/material.dart';
import 'firebase_services.dart';

class ProfileViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create an instance of FirebaseServices
    final FirebaseServices firebaseServices = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Views'),
      ),
      body: FutureBuilder<List<String>>(
        future: firebaseServices.getProfileViews(), // Call the method on the instance
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final views = snapshot.data ?? [];
            return ListView.builder(
              itemCount: views.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(views[index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
