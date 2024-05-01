// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';

class ScreenLockHelper {
  static Widget dotBuilder(bool enabled, SecretConfig config) {
    return Container(
      width: config.size,
      height: config.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? config.enabledColor : config.disabledColor,
        border: Border.all(width: config.borderSize, color: config.borderColor),
      ),
    );
  }

  static SecretsConfig secretsConfig(ColorScheme colorScheme) {
    return SecretsConfig(
      padding: const EdgeInsets.only(
        top: ConfigConstant.objectHeight1,
        bottom: ConfigConstant.objectHeight1,
      ),
      secretConfig: SecretConfig(
        borderColor: colorScheme.primary,
        enabledColor: colorScheme.primary,
        size: 12,
        builder: (context, config, enabled) => dotBuilder(enabled, config),
      ),
    );
  }

  static ScreenLockConfig screenLockConfig(
      ColorScheme colorScheme, BuildContext context, TextTheme textTheme) {
    return ScreenLockConfig(
      backgroundColor: colorScheme.surface,
      themeData: Theme.of(context).copyWith(
        textTheme: TextTheme(
          displayLarge:
              textTheme.displayLarge?.copyWith(color: colorScheme.onSurface),
          titleLarge:
              textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          titleMedium:
              textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
          bodyMedium:
              textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }

  static KeyPadConfig keyPadConfig(
      TextTheme textTheme, ColorScheme colorScheme) {
    return KeyPadConfig(
      clearOnLongPressed: true,
      buttonConfig: KeyPadButtonConfig(
        fontSize: textTheme.headlineSmall?.fontSize,
        foregroundColor: colorScheme.onSecondaryContainer,
        backgroundColor: colorScheme.secondaryContainer,
        buttonStyle: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.large),
          side: BorderSide(
            style: BorderStyle.none,
            color: colorScheme.secondaryContainer,
          ),
        ),
      ),
    );
  }
}
