import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage class

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    while (_progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 10));
      setState(() {
        _progress += 0.01;
      });
    }

    // Navigate to the LoginPage once loading is complete
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your LoginPage class
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo image
          Image.asset(
            'assets/loginlogo.png', // Replace with your image path
            height: 130, // Set the desired height for the image
          ),
          const SizedBox(height: 8), // Space between logo and progress bar
          // LinearProgressIndicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130.0), // Add padding to the sides
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              value: _progress,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple), // Progress color
              minHeight: 5, // Height of the progress bar
            ),
          ),
        ],
      ),
    );
  }
}
