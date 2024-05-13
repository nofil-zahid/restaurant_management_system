import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final String routeName;
  final List<String> allowedRoles;

  MenuItem({
    required this.icon,
    required this.title,
    required this.routeName,
    required this.allowedRoles,
  });

  
}
