import 'package:flutter/material.dart';
import 'package:restaurant_management_system/routes/footer_routes.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {

  // late SharedPref pref;
  late String role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initiatePreference();
    role = getRole();
    print("role => ${role}");
  }

  // void initiatePreference() async {
  //   pref = SharedPref();
  //   await pref.init();
  // }

  String getRole() {
    return  "admin"; // pref.getValue("ROLE") ??
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: 
        footer_routes
          .where((element) => element.allowedRoles.contains(role))
          .map((e) => BottomNavigationBarItem(icon: Icon(e.icon), label: e.title, backgroundColor: Colors.black26))
          .toList(),
      onTap: (index) {
        Navigator.pushNamed(context, footer_routes[index].routeName);
      },
    );
  }
}
