import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String userType = 'shop_owner';
  String? selectedCompany;
  List<String> companies = [];

  // Form Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _businessLocationController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyLocationController = TextEditingController();
  final TextEditingController _branchLocationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    try {
      final QuerySnapshot companySnapshot = await _firestore.collection('company').get();
      setState(() {
        companies = companySnapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['companyName'] as String)
            .toList();
      });
    } catch (e) {
      print('Error fetching companies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xA9231942),
      appBar: AppBar(
        backgroundColor: const Color(0xFF231942),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
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
                      const SizedBox(height: 16.0),
                      Image.asset(
                        "assets/loginlogo.png",
                        height: 150,
                      ),
                      const SizedBox(height: 16.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: userType,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7C6FF),
                                contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  userType = newValue!;
                                  selectedCompany = null; // Reset selected company when user type changes
                                });
                              },
                              items: <String>['shop_owner', 'sales_representative', 'company']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.capitalize()),
                                );
                              }).toList(),
                            ),
                            if (userType == 'company') ...[
                              _buildTextField(_companyNameController, "Company Name"),
                              _buildTextField(_companyLocationController, "Company Location"),
                            ],
                            _buildTextField(_emailController, "Email", keyboardType: TextInputType.emailAddress),
                            _buildTextField(_phoneController, "Phone Number", keyboardType: TextInputType.phone),
                            _buildTextField(_passwordController, "Password", obscureText: true),
                            _buildTextField(_confirmPasswordController, "Confirm Password", obscureText: true),
                            if (userType == 'shop_owner') ...[
                              _buildTextField(_shopNameController, "Shop Name"),
                              _buildTextField(_businessLocationController, "Business Location"),
                            ] else if (userType == 'sales_representative') ...[
                              _buildCompanyDropdown(),
                              _buildTextField(_branchLocationController, "Branch Location"),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF8906E6),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedCompany,
        decoration: const InputDecoration(
          hintText: "Select Company",
          filled: true,
          fillColor: Color(0xFFE7C6FF),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        items: companies.map((String company) {
          return DropdownMenuItem<String>(
            value: company,
            child: Text(company),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCompany = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a company';
          }
          return null;
        },
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
          fillColor: const Color(0xFFE7C6FF),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Map<String, dynamic> userData = {
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'user_type': userType,
        };

        if (userType == 'shop_owner') {
          userData.addAll({
            'shop_name': _shopNameController.text.trim(),
            'business_location': _businessLocationController.text.trim(),
          });
          await _firestore.collection('shop_owner').doc(userCredential.user?.uid).set(userData);
        } else if (userType == 'sales_representative') {
          userData.addAll({
            'company': selectedCompany,
            'branchLocation': _branchLocationController.text.trim(),
          });
          await _firestore.collection('sales-rep').doc(userCredential.user?.uid).set(userData);
        } else if (userType == 'company') {
          userData.addAll({
            'companyName': _companyNameController.text.trim(),
            'companyLocation': _companyLocationController.text.trim(),
          });
          await _firestore.collection('company').doc(userCredential.user?.uid).set(userData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign up successful!")),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign up failed: ${e.message}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return isNotEmpty ? this[0].toUpperCase() + substring(1) : this;
  }
}
