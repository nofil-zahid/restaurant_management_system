import 'package:flutter/material.dart';
import 'package:restaurant_management_system/database/firestore_services.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, String> admin = {};
  Map<String, String> manager = {};
  Map<String, String> waiter = {};

  late SharedPref pref;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = initiatePreference();
  }

  Future<void> initiatePreference() async {
    pref = SharedPref();
    await pref.init();
    List<dynamic> fetchedUsers = await getAllUsers();
    print(fetchedUsers);

    // Filter users based on their roles
    if (fetchedUsers.isNotEmpty) {
      for (var user in fetchedUsers) {
        String? username = user['name'] ?? user['emp_name'];
        String? password = user['password'];
        String? role = user['role']?['role_des'];

        if (username != null && password != null) {
          switch (role) {
            case 'admin':
              admin[username] = password;
              break;
            case 'manager':
              manager[username] = password;
              break;
            case 'waiter':
              waiter[username] = password;
              break;
            default:
              // Handle users with no or unknown role
              break;
          }
        }
      }

      print("==== admin ====");
      print(admin);
      print("==== manager ====");
      print(manager);
      print("==== waiter ====");
      print(waiter);
    }
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (admin.containsKey(username) && admin[username] == password) {
      await pref.setValue("ROLE", "admin");
      await pref.setValue("USER", username);
      Navigator.pushNamed(context, "/admin");
    } else if (manager.containsKey(username) && manager[username] == password) {
      await pref.setValue("ROLE", "manager");
      await pref.setValue("USER", username);
      Navigator.pushNamed(context, "/m-home");
    } else if (waiter.containsKey(username) && waiter[username] == password) {
      await pref.setValue("ROLE", "waiter");
      await pref.setValue("USER", username);
      Navigator.pushNamed(context, "/w-home");
    } else if (username.trim().isEmpty || password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('EMPTY FIELDS'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('INCORRECT USERNAME OR PASSWORD'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
