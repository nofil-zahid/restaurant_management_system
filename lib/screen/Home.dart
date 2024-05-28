import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPref pref;
  late Future<String> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = initiatePreference();
  }

  Future<String> initiatePreference() async {
    pref = SharedPref();
    await pref.init();
    String currentUser = pref.getValue("USER") ?? "Admin";
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<String>(
        future: _currentUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          String currentUser = snapshot.data ?? "Admin";
          return Center(
            child: Text("Hello, $currentUser"),
          );
        },
      ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: const Footer(),
    );
  }
}
