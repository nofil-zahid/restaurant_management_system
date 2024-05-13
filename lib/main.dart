import 'package:flutter/material.dart';
import 'package:restaurant_management_system/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DineDynasty',
      routes: {
        for (var route in routeArr)
          route.routeLink: (context) => route.widget,
      },
      initialRoute: "/loading-screen",
    );
  }
}