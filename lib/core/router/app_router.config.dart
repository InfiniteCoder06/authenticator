// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/settings/default_route.settings.dart';
import 'package:authenticator/features/details/detail.screen.dart';
import 'package:authenticator/features/home/home.screen.dart';
import 'package:authenticator/features/not_found.screen.dart';
import 'package:authenticator/features/scan/scan.screen.dart';
import 'package:authenticator/features/settings/account/account.screen.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.screen.dart';
import 'package:authenticator/features/settings/logger/logger.screen.dart';
import 'package:authenticator/features/settings/security/security.screen.dart';
import 'package:authenticator/features/settings/settings.screen.dart';
import 'package:authenticator/features/settings/theme/theme.screen.dart';
import 'package:authenticator/features/transfer/transfer.screen.dart';
import 'app.router.dart';
import 'settings/base_route.settings.dart';

class AppRouteConfig {
  final RouteSettings? settings;
  final BuildContext context;

  Map<AppRouter, BaseRouteSetting> routes = {};
  AppRouteConfig({
    required this.context,
    this.settings,
  }) {
    _setup();
  }

  Route<dynamic> generate() {
    AppRouter router = AppRouter.notFound;
    for (AppRouter element in AppRouter.values) {
      if (settings?.name == element.path) {
        router = element;
        break;
      }
    }
    BaseRouteSetting? setting = routes[router];
    return setting!.toRoute(context, settings);
  }

  void _setup() {
    routes.clear();
    for (AppRouter path in AppRouter.values) {
      routes[path] = buildRoute(path);
    }
  }

  BaseRouteSetting buildRoute(AppRouter router) {
    switch (router) {
      case AppRouter.home:
        return DefaultRouteSetting(
          route: (context) => const EntryOverviewPage(),
        );
      case AppRouter.details:
        return DefaultRouteSetting(
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is DetailPageArgs) {
              return DetailPage(
                key: arguments.key,
                item: optionOf(arguments.item),
                isUrl: arguments.isUrl,
              );
            }
            return DetailPage(
              item: none(),
              isUrl: false,
            );
          },
        );
      case AppRouter.scan:
        return DefaultRouteSetting(
          route: (context) => const ScanPage(),
        );
      case AppRouter.transfer:
        return DefaultRouteSetting(
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is TransferPageArgs) {
              return TransferPage(items: arguments.items);
            }
            return const NotFoundPage();
          },
        );
      case AppRouter.settings:
        return DefaultRouteSetting(
          route: (context) => const SettingsOverviewPage(),
        );
      case AppRouter.account:
        return DefaultRouteSetting(
          route: (context) => const AccountSettingsPage(),
        );
      case AppRouter.theme:
        return DefaultRouteSetting(
          route: (context) => const ThemeSettingsPage(),
        );
      case AppRouter.behavior:
        return DefaultRouteSetting(
          route: (context) => const BehaviourSettingsPage(),
        );
      case AppRouter.logger:
        return DefaultRouteSetting(
          route: (context) => const LogConsolePage(),
        );
      case AppRouter.security:
        return DefaultRouteSetting(
          route: (context) => const SecuritySettingsPage(),
        );
      case AppRouter.lock:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is SecurityPageArgs) {
              return PopScope(
                canPop: arguments.canCancel && arguments.onCancelled == null,
                onPopInvoked: (didPop) async {
                  if (didPop) return;
                },
                child: ScreenLock(
                  correctString: arguments.correctString,
                  onUnlocked: arguments.onUnlocked,
                  onOpened: arguments.onOpened,
                  onValidate: arguments.onValidate,
                  onCancelled: arguments.onCancelled,
                  onError: arguments.onError,
                  onMaxRetries: arguments.onMaxRetries,
                  maxRetries: arguments.maxRetries,
                  retryDelay: arguments.retryDelay,
                  title: arguments.title,
                  config: arguments.config,
                  secretsConfig: arguments.secretsConfig,
                  keyPadConfig: arguments.keyPadConfig,
                  delayBuilder: arguments.delayBuilder,
                  customizedButtonChild: arguments.customizedButtonChild,
                  customizedButtonTap: arguments.customizedButtonTap,
                  footer: arguments.footer,
                  cancelButton: arguments.cancelButton,
                  deleteButton: arguments.deleteButton,
                  inputController: arguments.inputController,
                  secretsBuilder: arguments.secretsBuilder,
                  useBlur: arguments.useBlur,
                  useLandscape: arguments.useLandscape,
                ),
              );
            } else if (arguments is SecurityCreatePageArgs) {
              return PopScope(
                canPop: arguments.canCancel && arguments.onCancelled == null,
                onPopInvoked: (didPop) async {
                  if (didPop) return;
                },
                child: ScreenLock.create(
                  onConfirmed: arguments.onConfirmed,
                  onOpened: arguments.onOpened,
                  onValidate: arguments.onValidate,
                  onCancelled: arguments.onCancelled,
                  onError: arguments.onError,
                  onMaxRetries: arguments.onMaxRetries,
                  maxRetries: arguments.maxRetries,
                  digits: arguments.digits,
                  retryDelay: arguments.retryDelay,
                  title: arguments.title,
                  confirmTitle: arguments.confirmTitle,
                  config: arguments.config,
                  secretsConfig: arguments.secretsConfig,
                  keyPadConfig: arguments.keyPadConfig,
                  delayBuilder: arguments.delayBuilder,
                  customizedButtonChild: arguments.customizedButtonChild,
                  customizedButtonTap: arguments.customizedButtonTap,
                  footer: arguments.footer,
                  cancelButton: arguments.cancelButton,
                  deleteButton: arguments.deleteButton,
                  inputController: arguments.inputController,
                  secretsBuilder: arguments.secretsBuilder,
                  useBlur: arguments.useBlur,
                  useLandscape: arguments.useLandscape,
                ),
              );
            }
            return const NotFoundPage();
          },
        );
      case AppRouter.notFound:
        return DefaultRouteSetting(
          route: (context) => const NotFoundPage(),
        );
    }
  }
}
