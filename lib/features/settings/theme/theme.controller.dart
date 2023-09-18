// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpie/riverpie.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'theme.state.dart';

final themeController = NotifierProvider<ThemeController, ThemeState>(
    (ref) => ThemeController(ref.read(hiveStorageProvider)));

class ThemeController extends PureNotifier<ThemeState> with ConsoleMixin {
  final StorageService storageService;

  ThemeController(this.storageService);

  @override
  ThemeState init() => ThemeState.initial();

  @override
  void postInit() async {
    var dynamicColor =
        await storageService.get<bool>(kdynamicColor, defaultValue: false);
    final themeModeDb =
        await storageService.get<int>(kthemeMode, defaultValue: 0);
    var themeMode = ThemeMode.values.elementAt(themeModeDb);
    var themeAccent =
        await storageService.get<int>(kthemeAccent, defaultValue: 3);

    state = state.copyWith(
      dynamicColor: dynamicColor,
      themeMode: themeMode,
      themeAccent: themeAccent,
    );

    console.info("⚙️ Initialize");
    super.postInit();
  }

  void toggleThemeMode(ThemeMode themeMode) async {
    await storageService.put<int>(kthemeMode, themeMode.index);
    state = state.copyWith(themeMode: themeMode);
  }

  void setAccent(int index) async {
    await storageService.put<int>(kthemeAccent, index);
    state = state.copyWith(themeAccent: index);
  }

  void setDynamicColor(bool useDynamicColor) async {
    await storageService.put<bool>(kdynamicColor, useDynamicColor);
    state = state.copyWith(dynamicColor: useDynamicColor);
  }
}
