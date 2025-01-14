import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  final String collectionType;

  const AccountPage({Key? key, required this.collectionType}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _accountData;
  bool _isLoading = true;
  bool _isEditing = false;

  Map<String, TextEditingController> _controllers = {};

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
            _accountData = Map<String, dynamic>.from(snapshot.data() as Map<String, dynamic>)
              ..remove('createdAt')
              ..remove('userId');
            _isLoading = false;
            _initializeControllers();
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

  void _initializeControllers() {
    if (_accountData != null) {
      _controllers = _accountData!.map((key, value) {
        return MapEntry(key, TextEditingController(text: value?.toString() ?? ""));
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        Map<String, dynamic> updatedData = {};

        // Collect only the fields that have changed
        _controllers.forEach((key, controller) {
          if (controller.text != _accountData![key]) {
            updatedData[key] = controller.text;
          }
        });

        if (updatedData.isNotEmpty) {
          await _firestore.collection(widget.collectionType).doc(currentUser.uid).update(updatedData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account details updated successfully!")),
          );
          setState(() {
            _isEditing = false;
            _accountData!.addAll(updatedData);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No changes made")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating details: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Details"),
        backgroundColor: const Color(0xFFF3E5F5),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _accountData == null
          ? const Center(child: Text("No account details available"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...(_isEditing ? _buildEditForm() : _buildAccountDetails()),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 10,
                        backgroundColor: const Color(0xFF6A1B9A),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAccountDetails() {
    return _accountData!.entries
        .where((entry) => entry.key != 'logo' && entry.key != 'logoUrl') // Exclude 'logo' and 'logoUrl'
        .map((entry) {
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

  List<Widget> _buildEditForm() {
    return _controllers.entries
        .where((entry) => entry.key != 'logo' && entry.key != 'logoUrl') // Exclude 'logo' and 'logoUrl'
        .map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: entry.value,
          decoration: InputDecoration(
            labelText: entry.key.replaceAll('_', ' ').toUpperCase(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
        ),
      );
    }).toList();
  }
}
