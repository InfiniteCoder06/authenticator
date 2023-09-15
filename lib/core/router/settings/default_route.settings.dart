// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/settings/base_route.settings.dart';

class DefaultRouteSetting<T> extends BaseRouteSetting<T> {
  DefaultRouteSetting({
    required super.route,
    super.fullscreenDialog,
  });

  @override
  Route<T> toRoute(BuildContext context, RouteSettings? settings) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return MaterialPageRoute<T>(
          builder: route,
          settings: RouteSettings(arguments: this, name: settings?.name),
          fullscreenDialog: fullscreenDialog,
        );

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return SwipeablePageRoute<T>(
          canSwipe: true,
          builder: route,
          settings: RouteSettings(arguments: this, name: settings?.name),
          fullscreenDialog: fullscreenDialog,
        );
    }
  }
}
