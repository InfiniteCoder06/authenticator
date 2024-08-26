// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'behaviour.controller.g.dart';
part 'behaviour.state.dart';

@Riverpod(keepAlive: true)
class BehaviorController extends _$BehaviorController with ConsoleMixin {
  @override
  BehaviorState build() {
    postInit();
    return BehaviorState.initial();
  }

  void postInit() async {
    final storageService = ref.read(hiveStorageProvider);
    final copyOnTap =
        await storageService.get<bool>(kCopyOnTap, defaultValue: true);
    final searchOnStart =
        await storageService.get<bool>(kSearchOnTap, defaultValue: false);
    final fontSize = await storageService.get<int>(kFontSize, defaultValue: 25);
    final codeGroup =
        await storageService.get<int>(kCodeGroup, defaultValue: 3);

    state = state.copyWith(
      copyOnTap: copyOnTap,
      searchOnStart: searchOnStart,
      codeGroup: codeGroup,
      fontSize: fontSize,
    );

    console.info("⚙️ Initialize");
  }

  Future<void> toggleCopyOnTap(bool value) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<bool>(kCopyOnTap, value);
    state = state.copyWith(copyOnTap: value);
  }

  Future<void> toggleSearchOnStart(bool value) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<bool>(kSearchOnTap, value);
    state = state.copyWith(searchOnStart: value);
  }

  Future<void> setFontSize(int fontSize) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<int>(kFontSize, fontSize);
    state = state.copyWith(fontSize: fontSize);
  }

  Future<void> setCodeGroup(int codeGroup) async {
    final storageService = ref.read(hiveStorageProvider);
    await storageService.put<int>(kCodeGroup, codeGroup);
    state = state.copyWith(codeGroup: codeGroup);
  }
}
