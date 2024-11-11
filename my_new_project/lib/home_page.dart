import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construction Buddies'),
        backgroundColor: Colors.blue[800], // Softer blue for better contrast
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/companyReg');
            },
            child: const Text(
              'Company Profile Creation',
              style: TextStyle(color: Colors.orangeAccent, fontSize: 16), // Orange text for improved visibility
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent, // Bright accent color for header
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.account_circle, color: Colors.orangeAccent),
                    title: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profileCreation');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.build, color: Colors.orangeAccent),
                    title: const Text(
                      'Find Suppliers',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/jobMatching');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.message, color: Colors.orangeAccent),
                    title: const Text(
                      'Messages',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/messages');
                    },
                  ),
                ],
              ),
            ),
            // Menu items positioned at the bottom
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance, color: Colors.orangeAccent),
                  title: const Text(
                    'Manage Account',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/manageAccount');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.support, color: Colors.orangeAccent),
                  title: const Text(
                    'Support',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/support');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.orangeAccent),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.orangeAccent),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                  onTap: () {
                    // Add log out functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[800], // Unified background color for a consistent look
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.construction,
              size: 120,
              color: Colors.orangeAccent, // Bright icon for better contrast
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Construction Buddies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/jobMatching');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent, // Bright button for user-friendly design
                foregroundColor: Colors.black, // Black text for readability
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Find Suppliers'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/messages');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent, // Consistent button color
                foregroundColor: Colors.black, // Black text for readability
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Messages'),
            ),
          ],
        ),
      ),
    );
  }
}
