// 🐦 Flutter imports:
import 'package:flutter/material.dart';

abstract class BaseRouteSetting<T> {
  BaseRouteSetting({
    required this.route,
    this.fullscreenDialog = false,
  });

  final Widget Function(dynamic) route;
  final bool fullscreenDialog;

  Route<T> toRoute(BuildContext context, RouteSettings? settings);
}
