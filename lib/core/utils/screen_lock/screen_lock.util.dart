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
  ValidationCallback? onValidate,
  VoidCallback? onCancelled,
  ValueChanged<int>? onError,
  ValueChanged<int>? onMaxRetries,
  int maxRetries = 5,
  Duration retryDelay = const Duration(seconds: 30),
  Widget? title,
  DelayBuilderCallback? delayBuilder,
  Widget? customizedButtonChild,
  VoidCallback? customizedButtonTap,
  Widget? footer,
  Widget? cancelButton,
  Widget? deleteButton,
  InputController? inputController,
  SecretsBuilderCallback? secretsBuilder,
  bool useBlur = true,
  bool useLandscape = false,
  bool canCancel = false,
}) async {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  TextTheme textTheme = Theme.of(context).textTheme;

  title = title ??
      Text(
        "Enter Passcode",
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
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
        onValidate: onValidate,
        onCancelled: onCancelled,
        onError: onError,
        onMaxRetries: onMaxRetries,
        maxRetries: maxRetries,
        retryDelay: retryDelay,
        title: title,
        config: screenLockConfig,
        secretsConfig: secretsConfig,
        keyPadConfig: keyPadConfig,
        delayBuilder: delayBuilder,
        customizedButtonChild: customizedButtonChild,
        customizedButtonTap: customizedButtonTap,
        footer: footer,
        cancelButton: cancelButton,
        deleteButton: deleteButton,
        inputController: inputController,
        secretsBuilder: secretsBuilder,
        useBlur: useBlur,
        useLandscape: useLandscape,
        canCancel: canCancel,
      ));
}

Future<T?> showEnhancedCreateScreenLock<T>({
  required BuildContext context,
  required ValueChanged<String> onConfirmed,
  VoidCallback? onOpened,
  ValidationCallback? onValidate,
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
  Widget? footer,
  Widget? cancelButton,
  Widget? deleteButton,
  InputController? inputController,
  SecretsBuilderCallback? secretsBuilder,
  bool useBlur = true,
  bool useLandscape = false,
  bool canCancel = false,
}) async {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  TextTheme textTheme = Theme.of(context).textTheme;

  title = title ??
      Text(
        "Set Pin Code",
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      );

  confirmTitle = confirmTitle ??
      Text(
        "Confirm Passcode",
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
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
        onValidate: onValidate,
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
        delayBuilder: delayBuilder,
        customizedButtonChild: customizedButtonChild,
        customizedButtonTap: customizedButtonTap,
        footer: footer,
        cancelButton: cancelButton,
        deleteButton: deleteButton,
        inputController: inputController,
        secretsBuilder: secretsBuilder,
        useBlur: useBlur,
        useLandscape: useLandscape,
        canCancel: canCancel,
      ));
}
