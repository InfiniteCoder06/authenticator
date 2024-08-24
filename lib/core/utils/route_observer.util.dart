// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/features/home/home.controller.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final WidgetRef ref;

  CustomNavigatorObserver({required this.ref});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print(
        "Route pushed: ${route.settings.name} from ${previousRoute?.settings.name}");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print(
        "Route popped: ${previousRoute?.settings.name} from ${route.settings.name}");
    if (route.settings.name == '/details' &&
        previousRoute?.settings.name == '/') {
      ref.refresh(getAllItemProvider);
      ref.refresh(showBackupNotiProvider);
    }

    if ((route.settings.name == '/settings/accounts' ||
            route.settings.name == '/settings') &&
        previousRoute?.settings.name == '/') {
      ref.refresh(getAllItemProvider);
      ref.refresh(showBackupNotiProvider);
    }

    if (route.settings.name == 'DeletionDialog' &&
        previousRoute?.settings.name == '/') {
      ref.refresh(getAllItemProvider);
      ref.refresh(showBackupNotiProvider);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print(
        "Route removed: ${route.settings.name} from ${previousRoute?.settings.name}");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print(
        "Route replaced: ${newRoute?.settings.name} from ${oldRoute?.settings.name}");
  }
}
