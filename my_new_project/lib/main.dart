import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:google_sign_in_web/google_sign_in_web.dart';  // For web Google Sign-In
import 'loading_screen.dart'; // Import your loading screen
import 'home_page.dart'; // Import HomeScreen
import 'profile_creation.dart'; // Import ProfileCreationScreen
import 'job_matching.dart'; // Import JobMatchingScreen
import 'messages_screen.dart'; // Import MessagesScreen
import 'contacts_screen.dart';  // Import the ContactsScreen
import 'companyreg.dart';
import 'manage_account.dart'; // Add this line
import 'settings.dart';
import 'support.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Enable  offline  persistance
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB82m2AT9f57jGImFX15WO5MW8AM7HiTvY",
      authDomain: "com.example.my_new_project",
      projectId: "mynew-roject",
      storageBucket: "YOUR_PROJECT_ID.appspot.com",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      appId: "YOUR_APP_ID",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Buddies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[900], // Blue background
      ),
      // Set the initial screen to the loading screen
      home: const LoadingScreen(),
      // Define the routes for easy navigation
      routes: {
        '/homepage': (context) => const HomeScreen(),  // Updated home screen reference
        '/profileCreation': (context) => ProfilePage(),
        '/jobMatching': (context) => const JobMatchingScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/contacts': (context) => ContactsScreen(), // Assumes ContactsScreen is implemented
        '/companyReg': (context) => CompanyRegPage(),  // Ensure this route is defined
        '/manageAccount': (context) => ManageAccountPage(), // Manage account
        '/settings': (context) => SettingsPage(), // Settings
        '/support': (context) => SupportPage(), // Support
        '/login_screen.dart': (context) => const LoginScreen(), // Support

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
