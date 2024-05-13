// ignore_for_file: constant_pattern_never_matches_value_type, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:restaurant_management_system/database/database_service.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPref pref;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    // local-storage
    initiatePreference();
    // db storage
    _databaseService = DatabaseService();
    _databaseService.openDatabaseConnection();
  }

  void initiatePreference() async {
    pref = SharedPref();
    await pref.init();
  }

  Future<void> _login() async {

    String username = _usernameController.text;
    String password = _passwordController.text;

    List<String> admin = ["nofil"];
    List<String> manager = ["daniyal", "osama", "waseem"];
    List<String> waiter = ["ziyan", "haseeb", "ahsan", "usman", "ahmad", "anwar", "ahtasham"];

    if (admin.contains(username) && (password=="admin")) {
      await pref.setValue("ROLE", "admin");
      Navigator.pushNamed(context, "/admin");
    }
    else if (manager.contains(username) && (password=="passM")) {
      await pref.setValue("ROLE", "manager");
      Navigator.pushNamed(context, "/m-home");
    }
    else if (waiter.contains(username) && (password=="passW")) {
      await pref.setValue("ROLE", "waiter");
      Navigator.pushNamed(context, "/w-home");
    }
    else {
      print("INCORRECT CREDENTIALS");
    }

    // Map<String, dynamic>? userData = await _databaseService.authenticateUser(username, password);
    // print(username);
    // if (userData != null) {
    //   // User authenticated successfully
    //   // Here you can store user data in shared preferences or proceed to another screen
    //   print('User authenticated: $userData');
    // } else {
    //   // Invalid credentials or user not found
    //   print('Invalid credentials');
    // }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
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
            // ElevatedButton(
            //   onPressed: () {
            //     print("username=> ${_usernameController.text}");
            //     print("password => ${_passwordController.text}");

            //     switch (_usernameController.text) {
            //       case "manager":
            //         Navigator.pushNamed(context, "/manager-home");
            //         break;
            //       case "waiter":
            //         Navigator.pushNamed(context, "/waiter-home");
            //         break;
            //       case "admin":
            //         // Navigator.pushNamed(context, "/admin");
            //         print("ABHI SBR KR");
            //         break;
            //       default:
            //         print("CHLA KI LBDA PHIRE, SALAY DA GHR KOI NAAA... LOKA TO PUCHDA PHIRE");
            //     }
            //   },
            //   child: const Text('Login'),
            // ),
          ],
        ),
      ),
    );
  }
}
