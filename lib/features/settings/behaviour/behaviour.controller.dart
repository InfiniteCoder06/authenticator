// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'behaviour.controller.g.dart';
part 'behaviour.state.dart';

@riverpod
class BehaviorController extends _$BehaviorController with ConsoleMixin {
  @override
  BehaviorState build() {
    postInit();
    return BehaviorState.initial();
  }

  void postInit() async {
    final storageService = ref.read(hiveStorageProvider);
    var copyOnTap =
        await storageService.get<bool>(kCopyOnTap, defaultValue: false);
    final fontSize = await storageService.get<int>(kFontSize, defaultValue: 25);
    var codeGroup = await storageService.get<int>(kCodeGroup, defaultValue: 3);

    state = state.copyWith(
      copyOnTap: copyOnTap,
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
