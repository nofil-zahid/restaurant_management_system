import 'package:flutter/material.dart';
import 'package:restaurant_management_system/routes/sidebar_routes.dart';
import 'package:restaurant_management_system/classes/route.dart' as _MyAppRoute;
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late List<_MyAppRoute.Router> approute;
  late SharedPref pref;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    approute = getRoleBasedRoutes();
    initiatePreference();

  }

  Future<void> initiatePreference() async {
    pref = SharedPref();
    await pref.init();
    setState(() {
      _userController.text = pref.getValue("USER") ?? "USER-NAME";
      _roleController.text = pref.getValue("ROLE") ?? "USER-ROLE";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            accountName: Text(
              _userController.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(_roleController.text),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (var item in approute)
                  ListTile(
                    leading: Icon(item.icon),
                    title: Text(
                      item.title,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, item.routeLink);
                    },
                  ),
                Divider(),
              ],
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/settings');
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Add logout functionality here
              Navigator.pushNamed(context, '/logout');
            },
          ),
        ],
      ),
    );
  }
}
