import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_management_system/database/firestore_services.dart'; // Make sure this path is correct
import 'package:restaurant_management_system/widgets/drawer.dart';

class EmpRegister extends StatefulWidget {
  const EmpRegister({super.key});

  @override
  State<EmpRegister> createState() => _EmpRegisterState();
}

class _EmpRegisterState extends State<EmpRegister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DocumentReference? selectedRole;
  List<Map<String, dynamic>> roles = [];

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  Future<void> loadRoles() async {
    List<Map<String, dynamic>> fetchedRoles = await fetchRoles();
    setState(() {
      roles = fetchedRoles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Register'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            DropdownButtonFormField<DocumentReference>(
              value: selectedRole,
              hint: const Text('Select Role Description'),
              onChanged: (DocumentReference? newValue) {
                setState(() {
                  selectedRole = newValue;
                });
              },
              items: roles.map((role) {
                return DropdownMenuItem<DocumentReference>(
                  value: FirebaseFirestore.instance.collection('roles').doc(role['id']),
                  child: Text(role['description']),
                );
              }).toList(),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = nameController.text;
                String password = passwordController.text;
                DocumentReference? roleRef = selectedRole;
                
                if (roleRef != null) {
                  bool success = await addUser(username, password, roleRef);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('NEW EMPLOYEE ADDED'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    setState(() {
                      nameController.text = "";
                      passwordController.text = "";
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('FAILED TO ADD NEW EMPLOYEE'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ROLE DESCRIPTION NOT SELECTED'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
