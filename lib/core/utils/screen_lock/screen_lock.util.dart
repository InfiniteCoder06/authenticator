// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/screen_lock/screen_lock.helper.dart';

Future<T?> showEnhancedScreenLock<T>({
  required BuildContext context,
  required VoidCallback onUnlocked,
  String correctString = '',
  VoidCallback? onOpened,
  VoidCallback? onCancelled,
  ValueChanged<int>? onError,
  ValueChanged<int>? onMaxRetries,
  int maxRetries = 5,
  Duration retryDelay = const Duration(seconds: 30),
  Widget? title,
  DelayBuilderCallback? delayBuilder,
  Widget? customizedButtonChild,
  VoidCallback? customizedButtonTap,
  Widget? cancelButton,
  Widget? deleteButton,
  SecretsBuilderCallback? secretsBuilder,
  bool useBlur = false,
  bool canCancel = false,
}) async {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  TextTheme textTheme = Theme.of(context).textTheme;

  title = Column(
    children: [
      const FlutterLogo(size: 100),
      title ?? Text("Unlock", style: textTheme.titleLarge),
    ],
  );

  KeyPadConfig keyPadConfig =
      ScreenLockHelper.keyPadConfig(textTheme, colorScheme);
  SecretsConfig secretsConfig = ScreenLockHelper.secretsConfig(colorScheme);
  ScreenLockConfig screenLockConfig =
      ScreenLockHelper.screenLockConfig(colorScheme, context, textTheme);

  return await Navigator.of(context).pushNamed(AppRouter.lock.path,
      arguments: SecurityPageArgs(
        context: context,
        correctString: correctString,
        onUnlocked: onUnlocked,
        onOpened: onOpened,
        onCancelled: onCancelled,
        onError: onError,
        onMaxRetries: onMaxRetries,
        maxRetries: maxRetries,
        retryDelay: retryDelay,
        title: title,
        config: screenLockConfig,
        secretsConfig: secretsConfig,
        keyPadConfig: keyPadConfig,
        delayBuilder: (context, duration) {
          return Column(
            children: [
              const FlutterLogo(size: 100),
              Text(
                  "Max attempts reached, Try after ${duration.inSeconds} Seconds",
                  style: textTheme.titleMedium)
            ],
          );
        },
        customizedButtonChild: customizedButtonChild,
        customizedButtonTap: customizedButtonTap,
        cancelButton: const Icon(Icons.arrow_drop_down_rounded),
        deleteButton: const Icon(Icons.backspace_rounded),
        secretsBuilder: secretsBuilder,
        useBlur: useBlur,
        useLandscape: true,
        canCancel: canCancel,
      ));
}

Future<T?> showEnhancedCreateScreenLock<T>({
  required BuildContext context,
  required ValueChanged<String> onConfirmed,
  VoidCallback? onOpened,
  VoidCallback? onCancelled,
  ValueChanged<int>? onError,
  ValueChanged<int>? onMaxRetries,
  int maxRetries = 5,
  int digits = 4,
  Duration retryDelay = Duration.zero,
  Widget? title,
  Widget? confirmTitle,
  DelayBuilderCallback? delayBuilder,
  Widget? customizedButtonChild,
  VoidCallback? customizedButtonTap,
  Widget? cancelButton,
  Widget? deleteButton,
  SecretsBuilderCallback? secretsBuilder,
  bool useBlur = false,
  bool canCancel = true,
}) async {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  TextTheme textTheme = Theme.of(context).textTheme;

  title = Column(
    children: [
      const FlutterLogo(size: 100),
      title ?? Text("Set Pin Code", style: textTheme.titleLarge),
    ],
  );

  confirmTitle = Column(
    children: [
      const FlutterLogo(size: 100),
      confirmTitle ?? Text("Confirm Passcode", style: textTheme.titleLarge),
    ],
  );

  KeyPadConfig keyPadConfig =
      ScreenLockHelper.keyPadConfig(textTheme, colorScheme);
  SecretsConfig secretsConfig = ScreenLockHelper.secretsConfig(colorScheme);
  ScreenLockConfig screenLockConfig =
      ScreenLockHelper.screenLockConfig(colorScheme, context, textTheme);

  return await Navigator.of(context).pushNamed(AppRouter.lock.path,
      arguments: SecurityCreatePageArgs(
        context: context,
        onConfirmed: onConfirmed,
        onOpened: onOpened,
        onCancelled: onCancelled,
        onError: onError,
        onMaxRetries: onMaxRetries,
        maxRetries: maxRetries,
        digits: digits,
        retryDelay: retryDelay,
        title: title,
        confirmTitle: confirmTitle,
        config: screenLockConfig,
        secretsConfig: secretsConfig,
        keyPadConfig: keyPadConfig,
        delayBuilder: (context, duration) {
          return Text(
            "Max attempts reached, Try after ${duration.inSeconds} Seconds",
            style: textTheme.titleMedium,
          );
        },
        customizedButtonChild: customizedButtonChild,
        customizedButtonTap: customizedButtonTap,
        cancelButton: const Icon(Icons.arrow_drop_down_rounded),
        deleteButton: const Icon(Icons.backspace_rounded),
        secretsBuilder: secretsBuilder,
        useBlur: useBlur,
        useLandscape: true,
        canCancel: canCancel,
      ));
}
