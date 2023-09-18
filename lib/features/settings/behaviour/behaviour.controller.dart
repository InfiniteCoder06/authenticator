// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpie/riverpie.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'behaviour.state.dart';

final behaviorController = NotifierProvider<BehaviorController, BehaviorState>(
    (ref) => BehaviorController(storageService: ref.read(hiveStorageProvider)));

class BehaviorController extends PureNotifier<BehaviorState> with ConsoleMixin {
  final StorageService storageService;

  BehaviorController({required this.storageService});

  @override
  BehaviorState init() => BehaviorState.initial();

  @override
  void postInit() async {
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
    super.postInit();
  }

  Future<void> toggleCopyOnTap(bool value) async {
    await storageService.put<bool>(kCopyOnTap, value);
    state = state.copyWith(copyOnTap: value);
  }

  Future<void> setFontSize(int fontSize) async {
    await storageService.put<int>(kFontSize, fontSize);
    state = state.copyWith(fontSize: fontSize);
  }

  Future<void> setCodeGroup(int codeGroup) async {
    await storageService.put<int>(kCodeGroup, codeGroup);
    state = state.copyWith(codeGroup: codeGroup);
  }
}
