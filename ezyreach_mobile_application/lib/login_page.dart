import 'package:flutter/material.dart';
import 'shop_owner_dashboard.dart'; // Import ShopOwnerDashboard page
import 'sales_rep_dashboard.dart'; // Import SalesRepDashboard page
import 'signup_page.dart'; // Import SignupPage

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231942), // Deep blue background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset(
                    "assets/loginlogo.png",
                    height: 200, // Adjust the size as needed
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFFFF), // White text
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            filled: true,
                            fillColor: const Color(0xFFE7C6FF), // Light purple background for input
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: const Color(0xFFE7C6FF), // Light purple background for input
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Check for hardcoded credentials
                            if (_usernameController.text == "owner" &&
                                _passwordController.text == "owner") {
                              // Navigate to ShopOwnerDashboard
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShopOwnerDashboard(),
                                ),
                              );
                            } else if (_usernameController.text == "salesrep" &&
                                _passwordController.text == "salesrep") {
                              // Navigate to SalesRepDashboard
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalesRepDashboard(),
                                ),
                              );
                            } else {
                              // Show error message for invalid credentials
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Invalid username or password')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF8906E6), // Bold purple for button
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign in"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xFFFF00E2), // Vibrant pink for text
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to SignupPage when "Sign Up" is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Color(0xFFC484F1)),
                                ),
                              ],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xFFFFFFFF), // White text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
