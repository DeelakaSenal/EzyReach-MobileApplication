import 'package:ezyreach_mobile_application/ui/company_dashboard.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import Firebase options
import 'package:flutter/material.dart'; // Import Material package
import 'package:device_preview/device_preview.dart'; // Import DevicePreview package
// Import the LandingPage widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with proper error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Use platform-specific options
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(
    DevicePreview(
      enabled: true, // Enable DevicePreview
      builder: (context) => const MyApp(), // Wrap MyApp with DevicePreview
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup App', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme color
      ),
      home: const CompanyDashboard(), // Landing page
      locale: DevicePreview.locale(context), // Add locale for DevicePreview
      builder: DevicePreview.appBuilder, // Integrate DevicePreview builder
    );
  }
}
