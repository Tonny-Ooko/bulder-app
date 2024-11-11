import 'package:flutter/material.dart';
import 'login_screen.dart';  // Import your login page

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // 7 seconds loading time
      vsync: this,
    )..repeat(reverse: true); // Flickering effect for color and size

    // Define a color transition between yellow and blue
    _colorTween = ColorTween(begin: Colors.yellow, end: Colors.orange)
        .animate(_controller);

    // Simulate loading time and navigate to LoginScreen after the delay
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to LoginScreen after loading
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return FlickeringLogo(color: _colorTween.value!); // Pass flickering color
              },
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.yellow), // Loading indicator
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class FlickeringLogo extends StatelessWidget {
  final Color color;

  const FlickeringLogo({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 500), // Flickering effect speed
      scale: 1.1, // Slightly enlarged size
      child: Icon(
        Icons.construction, // Loading icon (you can change this to your own logo)
        size: 120, // Large size
        color: color, // Flickering color
      ),
    );
  }
}
