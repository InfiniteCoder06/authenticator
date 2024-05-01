// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/settings/base_route.settings.dart';

class AnimatedRouteSetting<T> extends BaseRouteSetting<T> {
  AnimatedRouteSetting({
    required super.route,
    super.fullscreenDialog,
  });

  @override
  Route<T> toRoute(BuildContext context, RouteSettings? settings) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              route(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 2.4),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.0, 2.4),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
          },
          settings: RouteSettings(arguments: this, name: settings?.name),
          fullscreenDialog: fullscreenDialog,
        );
    }
  }
}
