import 'package:flutter/material.dart';
import 'login_page.dart'; // Import LoginPage to navigate to it

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7C6FF), // Soft lavender background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: constraints.maxHeight * 0.05),
                // Logo Image
                Image.asset('assets/loginlogo.png', height: 200), // Replace with your image path

                SizedBox(height: constraints.maxHeight * 0.05),
                // Title Text with highlighted "EZYREACH"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w700, // Bold weight
                        color: Color(0xFF231942), // Deep purple color for the title
                        fontSize: 32, // Larger font size for prominence
                        letterSpacing: 1.2, // Spacing between letters
                        shadows: [
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.2), // Soft shadow for text
                          ),
                        ],
                      ),
                      children: [
                        TextSpan(
                          text: 'Reach your goals easily with ', // Regular text before "EZYREACH"
                        ),
                        TextSpan(
                          text: 'EZYREACH', // Highlighted part
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5F4C6E), // Deep violet color for "EZYREACH"
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                // Description Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'EZYREACH connects sales reps and shop owners, helping you find the right partnerships and grow effortlessly.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Color(0xFF231942), // Deep purple color for description
                      fontSize: 18, // Slightly larger text size
                      fontWeight: FontWeight.w400, // Light weight for body text
                      height: 1.5, // Increased line height for better readability
                      letterSpacing: 0.5, // Slight letter-spacing for readability
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05), // Space for button

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page when button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('Get Started', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: const Color(0xFFFFFFFF), // Deep violet button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    elevation: 5, // Button shadow for 3D effect
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
