// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/shape.constant.dart';

class ThemeConstant {
  static ThemeData getLightThemeData(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.small),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.medium),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        splashColor: colorScheme.onSurface.withOpacity(0.18),
      );

  static ThemeData getDarkThemeData(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.small),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: ShapeConstant.medium),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: colorScheme.onPrimaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        splashColor: colorScheme.onSurface.withOpacity(0.18),
      );

  static bool getDarkMode(BuildContext context, ThemeMode mode) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;

    if (mode == ThemeMode.light) {
      return false;
    } else if (mode == ThemeMode.dark) {
      return true;
    } else {
      return platformBrightness == Brightness.light ? false : true;
    }
  }
}
