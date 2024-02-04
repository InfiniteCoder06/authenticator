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
      padding:
          const EdgeInsets.only(top: 24, bottom: ConfigConstant.objectHeight2),
      secretConfig: SecretConfig(
        borderColor: colorScheme.onBackground,
        enabledColor: colorScheme.onBackground,
        disabledColor: const Color.fromARGB(0, 8, 6, 6),
        size: 12,
        builder: (context, config, enabled) =>
            ScreenLockHelper.dotBuilder(enabled, config),
      ),
    );
  }

  static ScreenLockConfig screenLockConfig(
      ColorScheme colorScheme, BuildContext context, TextTheme textTheme) {
    return ScreenLockConfig(
      backgroundColor: colorScheme.background.withOpacity(0.75),
      themeData: Theme.of(context).copyWith(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            side: BorderSide.none,
            backgroundColor: colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(borderRadius: ShapeConstant.large),
          ).copyWith(
              overlayColor: MaterialStateProperty.all(Colors.transparent)),
        ),
        textTheme: TextTheme(
          displayLarge:
              textTheme.titleLarge?.copyWith(color: colorScheme.onBackground),
          bodyMedium: textTheme.headlineSmall
              ?.copyWith(color: colorScheme.onBackground),
        ),
      ),
    );
  }

  static KeyPadConfig keyPadConfig(
    TextTheme textTheme,
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return KeyPadConfig(
      clearOnLongPressed: true,
      buttonConfig: KeyPadButtonConfig(
        fontSize: textTheme.headlineSmall?.fontSize,
        buttonStyle: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
