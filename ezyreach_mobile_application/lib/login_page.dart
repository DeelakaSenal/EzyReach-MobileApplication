import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shop_owner_dashboard.dart'; // Import ShopOwnerDashboard page
import 'sales_rep_dashboard.dart'; // Import SalesRepDashboard page
import 'signup_page.dart'; // Import SignupPage

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FocusNodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Use Firebase Authentication to sign in with email
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful login, check which type of user it is (shop owner or sales rep)
      User? user = userCredential.user;

      if (user != null) {
        // Query 'shop_owner' collection to check if this user is a shop owner
        QuerySnapshot shopOwnerSnapshot = await _firestore
            .collection('shop_owner')
            .where('email', isEqualTo: email)
            .get();

        if (shopOwnerSnapshot.docs.isNotEmpty) {
          // Navigate to Shop Owner Dashboard if the user is a shop owner
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShopOwnerDashboard(),
            ),
          );
        } else {
          // Query 'sales-rep' collection to check if this user is a sales representative
          QuerySnapshot salesRepSnapshot = await _firestore
              .collection('sales-rep')
              .where('email', isEqualTo: email)
              .get();

          if (salesRepSnapshot.docs.isNotEmpty) {
            // Navigate to Sales Rep Dashboard if the user is a sales representative
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SalesRepDashboard(),
              ),
            );
          } else {
            // If the user is neither a shop owner nor a sales rep
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No user found in both roles')),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found for that email')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose of focus nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Email or Username',
                            filled: true,
                            fillColor: Color(0xFFE7C6FF), // Light purple background for input
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (_) {
                            // Move focus to the password field when email is submitted
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Color(0xFFE7C6FF), // Light purple background for input
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            onFieldSubmitted: (_) {
                              // Trigger login when password field is submitted
                              _loginUser();
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _loginUser,
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
