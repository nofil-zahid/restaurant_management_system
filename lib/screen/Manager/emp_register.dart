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
  bool isLoading = false;
  bool isPasswordVisible = false;

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
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register New Employee',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<DocumentReference>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: 'Select Role Description',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
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
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !isPasswordVisible,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        String username = nameController.text;
                        String password = passwordController.text;
                        DocumentReference? roleRef = selectedRole;
                        
                        if (username.isNotEmpty && password.isNotEmpty && roleRef != null) {
                          setState(() {
                            isLoading = true;
                          });

                          bool success = await addUser(username, password, roleRef);
                          setState(() {
                            isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? 'NEW EMPLOYEE ADDED'
                                  : 'FAILED TO ADD NEW EMPLOYEE'),
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          if (success) {
                            setState(() {
                              nameController.text = "";
                              passwordController.text = "";
                              selectedRole = null;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields and select a role'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Add User'),
                    ),
                  ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
