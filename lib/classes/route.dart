import 'package:flutter/material.dart';

class Router {
  Widget? icon;
  final String routeLink;
  final Widget widget;
  final String title;
  List<String>? allowedRoles;

  Router({
    Widget? icon,
    required this.title,
    required this.routeLink,
    required this.widget,
    this.allowedRoles,
  });
}
