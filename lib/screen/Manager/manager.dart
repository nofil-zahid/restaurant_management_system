import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/widgets/footer.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';

class Manager extends StatefulWidget {
  const Manager({Key? key}) : super(key: key);

  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  late SharedPref pref;
  late Future<String> _currentUserFuture;
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUserFuture = initiatePreference();
  }

  Future<String> initiatePreference() async {
    pref = SharedPref();
    await pref.init();
    String currentUser = pref.getValue("USER") ?? "Manager";
    _roleController.text = pref.getValue("ROLE") ?? "Manager";
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        backgroundColor: Colors.teal,
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
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          String currentUser = snapshot.data ?? "Manager";
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Hello, $currentUser",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Role: ${_roleController.text}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/logout");
                    },
                    icon: Icon(Icons.logout),
                    label: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: const Footer(),
    );
  }
}
