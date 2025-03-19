import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Main Account Page
class AccountPage extends StatefulWidget {
  final String collectionType;

  const AccountPage({super.key, required this.collectionType});

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
            .collection(widget.collectionType)
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
          collectionType: widget.collectionType,
        ),
      ),
    ).then((_) => _fetchAccountDetails());
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
          children: _buildAccountDetails(),
        ),
      ),
    );
  }

  List<Widget> _buildAccountDetails() {
    return _accountData!.entries.map((entry) {
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
                entry.key.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              Text(
                entry.value ?? 'N/A',
                style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// Edit Account Page
class EditAccountPage extends StatefulWidget {
  final Map<String, dynamic> accountData;
  final String collectionType;

  const EditAccountPage({super.key, required this.accountData, required this.collectionType});

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = widget.accountData.map((key, value) {
      return MapEntry(key, TextEditingController(text: value?.toString() ?? ""));
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          Map<String, dynamic> updatedData = {};
          _controllers.forEach((key, controller) {
            updatedData[key] = controller.text;
          });

          await _firestore.collection(widget.collectionType).doc(currentUser.uid).update(updatedData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account details updated successfully!")),
          );
          Navigator.pop(context);
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
              ..._buildFormFields(),
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

  List<Widget> _buildFormFields() {
    return _controllers.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: entry.value,
          decoration: InputDecoration(
            labelText: entry.key.replaceAll('_', ' ').toUpperCase(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFF231942), width: 2),
            ),
          ),
          validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
        ),
      );
    }).toList();
  }
}
