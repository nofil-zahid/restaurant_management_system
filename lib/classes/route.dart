import 'package:flutter/material.dart';

class Router {
  final IconData icon;
  final String routeLink;
  final Widget widget;
  final String title;
  List<String>? allowedRoles;

  Router({
    required this.icon,
    required this.title,
    required this.routeLink,
    required this.widget,
    this.allowedRoles,
  });
}
