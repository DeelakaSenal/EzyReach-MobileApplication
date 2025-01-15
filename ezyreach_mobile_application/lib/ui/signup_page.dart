import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _selectedLogo;
  final ImagePicker _picker = ImagePicker();

  // Form Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopLocationController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyLocationController = TextEditingController();
  final TextEditingController _branchLocationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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

  Future<void> _pickLogo() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 600,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedLogo = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadLogo(String userId) async {
    if (_selectedLogo == null) return null;

    try {
      String fileName = 'company_logos/$userId.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(_selectedLogo!);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading logo: $e');
      return null;
    }
  }

  Widget _buildLogoUpload() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Company Logo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: _pickLogo,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE7C6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8906E6),
                  width: 2,
                ),
              ),
              child: _selectedLogo == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    color: Color(0xFF8906E6),
                    size: 32,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add Logo',
                    style: TextStyle(
                      color: Color(0xFF8906E6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedLogo!,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
          if (_selectedLogo != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                onPressed: () => setState(() => _selectedLogo = null),
                icon: const Icon(Icons.close, size: 16, color: Colors.white70),
                label: const Text(
                  'Remove Logo',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231942),
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
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFE7C6FF),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  userType = newValue!;
                                  selectedCompany = null;
                                  if (userType != 'company') {
                                    _selectedLogo = null;
                                  }
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
                              _buildLogoUpload(),
                              _buildTextField(_companyNameController, "Company Name"),
                              _buildTextField(_companyLocationController, "Company Location"),
                            ],
                            _buildTextField(_emailController, "Email", keyboardType: TextInputType.emailAddress),
                            _buildTextField(_phoneController, "Phone Number", keyboardType: TextInputType.phone),
                            _buildTextField(_passwordController, "Password", obscureText: true),
                            _buildTextField(_confirmPasswordController, "Confirm Password", obscureText: true),
                            if (userType == 'shop_owner') ...[
                              _buildTextField(_nameController, "Name"),
                              _buildTextField(_shopNameController, "Shop Name"),
                              _buildTextField(_shopLocationController, "Shop Location"),
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
        decoration: InputDecoration(
          hintText: "Select Company",
          filled: true,
          fillColor: const Color(0xFFE7C6FF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
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
          hintStyle: TextStyle(color: Colors.grey[800]),
          filled: true,
          fillColor: const Color(0xFFE7C6FF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
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

      if (userType == 'company' && _selectedLogo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload a company logo")),
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
          'createdAt': FieldValue.serverTimestamp(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'user_type': userType,
          'userId': userCredential.user?.uid,
        };

        if (userType == 'shop_owner') {
          userData.addAll({
            'name': _nameController.text.trim(),
            'shopName': _shopNameController.text.trim(),
            'shopLocation': _shopLocationController.text.trim(),
          });
          await _firestore.collection('shop_owner').doc(userCredential.user?.uid).set(userData);
        } else if (userType == 'sales_representative') {
          userData.addAll({
            'company': selectedCompany,
            'branchLocation': _branchLocationController.text.trim(),
          });
          await _firestore.collection('sales-rep').doc(userCredential.user?.uid).set(userData);
        } else if (userType == 'company') {
          String? logoUrl = await _uploadLogo(userCredential.user?.uid ?? '');
          userData.addAll({
            'companyName': _companyNameController.text.trim(),
            'companyLocation': _companyLocationController.text.trim(),
            'logoUrl': logoUrl ?? '',
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