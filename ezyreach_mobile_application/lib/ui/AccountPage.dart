import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _accountData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountDetails();
  }

  Future<void> _fetchAccountDetails() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snapshot = await _firestore
            .collection('shop_owner') // Adjust collection if needed
            .doc(currentUser.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            _accountData = snapshot.data() as Map<String, dynamic>;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching account details: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAccountPage(
          accountData: _accountData!,
        ),
      ),
    ).then((_) => _fetchAccountDetails()); // Refresh details after editing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Details"),
        backgroundColor: const Color(0xFFC484F1),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _accountData != null ? _navigateToEditPage : null,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _accountData == null
              ? const Center(child: Text("No account details available"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailCard("Full Name", _accountData!['full_name']),
                      _buildDetailCard("Email", _accountData!['email']),
                      _buildDetailCard("Phone", _accountData!['phone']),
                      _buildDetailCard("Shop Name", _accountData!['shop_name']),
                      _buildDetailCard("Business Location", _accountData!['business_location']),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailCard(String title, String? value) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class EditAccountPage extends StatefulWidget {
  final Map<String, dynamic> accountData;

  const EditAccountPage({super.key, required this.accountData});

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _shopNameController;
  late TextEditingController _businessLocationController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.accountData['full_name']);
    _phoneController = TextEditingController(text: widget.accountData['phone']);
    _shopNameController = TextEditingController(text: widget.accountData['shop_name']);
    _businessLocationController = TextEditingController(text: widget.accountData['business_location']);
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await _firestore.collection('shop_owner').doc(currentUser.uid).update({
            'full_name': _fullNameController.text,
            'phone': _phoneController.text,
            'shop_name': _shopNameController.text,
            'business_location': _businessLocationController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account details updated successfully!")),
          );
          Navigator.pop(context); // Close the EditAccountPage and go back to AccountPage
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating details: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account Details"),
        backgroundColor: const Color(0xFFC484F1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(_fullNameController, "Full Name"),
              _buildTextFormField(_phoneController, "Phone", keyboardType: TextInputType.phone),
              _buildTextFormField(_shopNameController, "Shop Name"),
              _buildTextFormField(_businessLocationController, "Business Location"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF231942),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF231942), width: 2),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
      ),
    );
  }
}
