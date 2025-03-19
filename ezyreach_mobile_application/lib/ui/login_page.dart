import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ui/shop_owner_dashboard.dart'; // Import ShopOwnerDashboard page
import '../ui/sales_rep_dashboard.dart'; // Import SalesRepDashboard page
import '../ui/company_dashboard.dart'; // Import CompanyDashboard page
import '../ui/signup_page.dart'; // Import SignupPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      // Sign in using Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        _showSnackbar('Login failed. Please try again.');
        return;
      }

      debugPrint('User logged in: ${user.email}');

      // Check if the user is a shop owner
      QuerySnapshot shopOwnerSnapshot = await _firestore
          .collection('shop_owner')
          .where('email', isEqualTo: email)
          .get();

      if (shopOwnerSnapshot.docs.isNotEmpty) {
        debugPrint('Navigating to ShopOwnerDashboard...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopOwnerDashboard()),
        );
        return;
      }

      // Check if the user is a sales representative
      QuerySnapshot salesRepSnapshot = await _firestore
          .collection('sales-rep')
          .where('email', isEqualTo: email)
          .get();

      if (salesRepSnapshot.docs.isNotEmpty) {
        debugPrint('Navigating to SalesRepDashboard...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SalesRepDashboard()),
        );
        return;
      }

      // Check if the user is a company
      QuerySnapshot companySnapshot = await _firestore
          .collection('company') // assuming you have a 'company' collection
          .where('email', isEqualTo: email)
          .get();

      if (companySnapshot.docs.isNotEmpty) {
        debugPrint('Navigating to CompanyDashboard...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompanyDashboard()), // Navigate to CompanyDashboard
        );
        return;
      }

      // No role matched
      _showSnackbar('No user found in any role');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      switch (e.code) {
        case 'user-not-found':
          _showSnackbar('No user found for that email');
          break;
        case 'wrong-password':
          _showSnackbar('Incorrect password');
          break;
        case 'invalid-email':
          _showSnackbar('Invalid email address');
          break;
        default:
          _showSnackbar('Error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      _showSnackbar('An unexpected error occurred. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231942),
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
                    height: 200,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
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
                            fillColor: Color(0xFFE7C6FF),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (_) {
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
                              fillColor: Color(0xFFE7C6FF),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            onFieldSubmitted: (_) {
                              _loginUser();
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _loginUser,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF8906E6),
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
                                  color: const Color(0xFFFF00E2),
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupPage()),
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
                                  color: const Color(0xFFFFFFFF),
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
