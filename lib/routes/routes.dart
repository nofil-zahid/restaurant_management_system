import 'package:flutter/material.dart';
import 'package:restaurant_management_system/classes/route.dart' as _MyAppRoute;

import 'package:restaurant_management_system/screen/Home.dart';
import 'package:restaurant_management_system/screen/LoadingPage.dart';
import 'package:restaurant_management_system/screen/Login.dart';
import 'package:restaurant_management_system/screen/Logout.dart';
import 'package:restaurant_management_system/screen/Manager/emp_register.dart';
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
  _MyAppRoute.Router(title: "Home", icon: Icons.home, routeLink: "/admin", widget: const Home(), allowedRoles: ['admin']),

  _MyAppRoute.Router(title: "Home", icon: Icons.home, routeLink: "/m-home", widget: const Manager(), allowedRoles: ['manager']),
  _MyAppRoute.Router(title: "Register Employee", icon: Icons.person, routeLink: "/m-emp-register", widget: const EmpRegister(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Employee Work", icon: Icons.place, routeLink: "/m-emp-work", widget: const EmpWork(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Food", icon: Icons.restaurant_menu, routeLink: "/m-food", widget: const Food(), allowedRoles: ['admin', 'manager']),
  _MyAppRoute.Router(title: "Statistics", icon: Icons.bar_chart, routeLink: "/m-stats", widget: const Stats(), allowedRoles: ['admin', 'manager']),


  _MyAppRoute.Router(title: "Home", icon: Icons.home, routeLink: "/w-home", widget: const Waiter(), allowedRoles: ['waiter']),
  _MyAppRoute.Router(title: "Bill", icon: Icons.receipt, routeLink: "/w-bill", widget: const Bill(), allowedRoles: ['admin', 'waiter']),
  _MyAppRoute.Router(title: "Order Management", icon: Icons.reorder, routeLink: "/w-order-manage", widget: const OrderManage(), allowedRoles: ['admin', 'waiter']),
  _MyAppRoute.Router(title: "Table Seating", icon: Icons.table_bar, routeLink: "/w-table-manage", widget: const TableManage(), allowedRoles: ['admin', 'waiter']),


  _MyAppRoute.Router(title: "Loading", icon: Icons.logout, routeLink: "/loading-screen", widget: const LoadingScreen(), allowedRoles: []),
  _MyAppRoute.Router(title: "", icon: Icons.plumbing, routeLink: "/login", widget: const LoginScreen(), allowedRoles: []),
  _MyAppRoute.Router(title: "Logout", icon: Icons.logout, routeLink: "/logout", widget: LogoutScreen(), allowedRoles: ["manager", "admin", "waiter"]),

];

