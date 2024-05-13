import 'package:flutter/material.dart';
// import 'package:restaurant_management_system/routes/footer_routes.dart';
import 'package:restaurant_management_system/routes/sidebar_routes.dart';
import 'package:restaurant_management_system/classes/route.dart' as _MyAppRoute;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  late List<_MyAppRoute.Router> approute;

  @override
  void initState() {
    super.initState();
    approute = getRoleBasedRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'My side bar',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          for (var item in approute) 
            ListTile(
              leading: item.icon ?? const Icon(Icons.error), // Provide a default icon
              title: Text(
                item.title,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pushNamed(context, item.routeLink);
              },
            ),
        ],
      ),
    );
  }
}
