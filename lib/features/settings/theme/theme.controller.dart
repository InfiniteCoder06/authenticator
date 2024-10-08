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

  Future<void> postInit() async {
    final storageService = ref.read(hiveStorageProvider);
    final dynamicColor =
        await storageService.get<bool>(kdynamicColor, defaultValue: false);
    final themeModeDb =
        await storageService.get<int>(kthemeMode, defaultValue: 0);
    final themeMode = ThemeMode.values.elementAt(themeModeDb);
    final themeAccent =
        await storageService.get<int>(kthemeAccent, defaultValue: 5);

    state = state.copyWith(
      dynamicColor: dynamicColor,
      themeMode: themeMode,
      themeAccent: themeAccent,
    );

    console.info("⚙️ Initialize");
  }

  Future<void> toggleThemeMode(ThemeMode themeMode) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<int>(kthemeMode, themeMode.index);
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> setAccent(int index) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<int>(kthemeAccent, index);
    state = state.copyWith(themeAccent: index);
  }

  Future<void> setDynamicColor(bool useDynamicColor) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<bool>(kdynamicColor, useDynamicColor);
    state = state.copyWith(dynamicColor: useDynamicColor);
  }
}
