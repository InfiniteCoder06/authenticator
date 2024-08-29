// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/features/home/home.controller.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  CustomNavigatorObserver({required this.ref});

  final WidgetRef ref;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
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
}
