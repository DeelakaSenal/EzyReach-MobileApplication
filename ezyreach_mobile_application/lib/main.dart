import 'package:flutter/material.dart';
import 'landing_page.dart'; // Import the LandingPage widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(), // Set LandingPage as the home screen
    );
  }
}
