// 🐦 Flutter imports:
import 'package:flutter/material.dart';

abstract class BaseRouteSetting<T> {
  final Widget Function(dynamic) route;
  final bool fullscreenDialog;

  BaseRouteSetting({
    required this.route,
    this.fullscreenDialog = false,
  });

  Route<T> toRoute(BuildContext context, RouteSettings? settings);
}
