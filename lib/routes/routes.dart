import 'package:flutter/material.dart';
import 'package:restaurant_management_system/classes/route.dart' as _MyAppRoute;

import 'package:restaurant_management_system/screen/Home.dart';
import 'package:restaurant_management_system/screen/LoadingPage.dart';
import 'package:restaurant_management_system/screen/Login.dart';
import 'package:restaurant_management_system/screen/Manager/emp_work.dart';
import 'package:restaurant_management_system/screen/Manager/food.dart';
import 'package:restaurant_management_system/screen/Manager/manager.dart';
import 'package:restaurant_management_system/screen/Manager/stats.dart';
import 'package:restaurant_management_system/screen/Register.dart';
import 'package:restaurant_management_system/screen/Waiter/bill.dart';
import 'package:restaurant_management_system/screen/Waiter/order_manage.dart';
import 'package:restaurant_management_system/screen/Waiter/table_manage.dart';
import 'package:restaurant_management_system/screen/Waiter/waiter.dart';

List<_MyAppRoute.Router> routeArr = [

  _MyAppRoute.Router(title: "Home", icon: const Icon(Icons.place), routeLink: "/m-home", widget: const Manager(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Register Employee", icon: const Icon(Icons.plumbing), routeLink: "/m-emp-register", widget: const Register(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Employee Spy Cam", icon: const Icon(Icons.plumbing), routeLink: "/m-emp-work", widget: const EmpWork(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Food", icon: const Icon(Icons.plumbing), routeLink: "/m-food", widget: const Food(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Statistics", icon: const Icon(Icons.plumbing), routeLink: "/m-stats", widget: const Stats(), allowedRoles: ['admin', 'manager']),


  _MyAppRoute.Router(title: "Home", icon: const Icon(Icons.plumbing), routeLink: "/w-home", widget: const Waiter(), allowedRoles: ['admin', 'waiter']),
  _MyAppRoute.Router(title: "Bill", icon: const Icon(Icons.plumbing), routeLink: "/w-bill", widget: const Bill(), allowedRoles: ['admin', 'waiter']),
  _MyAppRoute.Router(title: "Order Management", icon: const Icon(Icons.plumbing), routeLink: "/w-order-manage", widget: const OrderManage(), allowedRoles: ['admin', 'waiter']),
  _MyAppRoute.Router(title: "Table Seating", icon: const Icon(Icons.plumbing), routeLink: "/w-table-manage", widget: const TableManage(), allowedRoles: ['admin', 'waiter']),


  _MyAppRoute.Router(title: "Logout", icon: const Icon(Icons.plumbing), routeLink: "/loading-screen", widget: const LoadingScreen(), allowedRoles: ["manager", "admin", "waiter"]),
  _MyAppRoute.Router(title: "", icon: const Icon(Icons.plumbing), routeLink: "/login", widget: const LoginScreen(), allowedRoles: []),
  _MyAppRoute.Router(title: "", icon: const Icon(Icons.plumbing), routeLink: "/admin", widget: const Home(), allowedRoles: ['admin']),

];

