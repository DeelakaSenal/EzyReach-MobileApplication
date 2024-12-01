import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import the Firebase options file
import 'package:flutter/material.dart'; // Import Material package
import 'landing_page.dart'; // Import the LandingPage widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup App', // Updated title to reflect the purpose
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(), // Retain LandingPage as the home screen
    );
  }
}
