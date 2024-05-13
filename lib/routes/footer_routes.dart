import 'package:flutter/material.dart';
import 'package:restaurant_management_system/classes/menu_item.dart';
import 'routes.dart';

final List<MenuItem> footer_routes = [
  MenuItem(
    icon: Icons.home, 
    title: "Loading Page", 
    routeName: "/loading-screen", 
    allowedRoles: ["admin", "manager", "waiter"]
  ),
  MenuItem(
    icon: Icons.window_rounded, 
    title: "Home", 
    routeName: "/home", 
    allowedRoles: ["admin", "manager", "waiter"]
  ),
];