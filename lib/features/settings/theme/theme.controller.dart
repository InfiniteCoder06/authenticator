// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'theme.state.dart';
part 'theme.controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController with ConsoleMixin {
  @override
  ThemeState build() {
    postInit();
    return ThemeState.initial();
  }

  void postInit() async {
    final storageService = ref.read(hiveStorageProvider);
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
  }

  void toggleThemeMode(ThemeMode themeMode) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<int>(kthemeMode, themeMode.index);
    state = state.copyWith(themeMode: themeMode);
  }

  void setAccent(int index) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<int>(kthemeAccent, index);
    state = state.copyWith(themeAccent: index);
  }

  void setDynamicColor(bool useDynamicColor) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<bool>(kdynamicColor, useDynamicColor);
    state = state.copyWith(dynamicColor: useDynamicColor);
  }
}
