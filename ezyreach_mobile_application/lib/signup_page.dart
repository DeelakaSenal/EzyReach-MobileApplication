import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String userType = 'shop_owner';

  // Form Field Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _businessLocationController = TextEditingController();
  final TextEditingController _experienceLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xA9231942), // Deep blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF231942),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white, // Set the title color here
            fontWeight: FontWeight.bold, // Optional: make text bold
            fontSize: 20.0, // Optional: adjust font size
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.0),
                      Image.asset(
                        "assets/loginlogo.png",
                        height: 150, // Adjust size if needed
                      ),
                      SizedBox(height: 16.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: userType,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7C6FF), // Light purple
                                contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  userType = newValue!;
                                });
                              },
                              items: <String>['shop_owner', 'sales_representative']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.capitalize()),
                                );
                              }).toList(),
                            ),
                            _buildTextField(_fullNameController, "Full Name"),
                            _buildTextField(_emailController, "Email", keyboardType: TextInputType.emailAddress),
                            _buildTextField(_phoneController, "Phone Number", keyboardType: TextInputType.phone),
                            _buildTextField(_passwordController, "Password", obscureText: true),
                            _buildTextField(_confirmPasswordController, "Confirm Password", obscureText: true),
                            if (userType == 'shop_owner') ...[
                              _buildTextField(_shopNameController, "Shop Name"),
                              _buildTextField(_businessLocationController, "Business Location"),
                            ] else ...[
                              _buildTextField(_experienceLevelController, "Company"),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF8906E6), // Bold purple for button
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Sign Up"),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText, {
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          filled: true,
          fillColor: const Color(0xFFE7C6FF), // Light purple background for input
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process the form data, e.g., send to backend
    }
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return this.isNotEmpty ? this[0].toUpperCase() + this.substring(1) : this;
  }
}
