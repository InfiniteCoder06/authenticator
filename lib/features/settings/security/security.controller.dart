// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'security.controller.g.dart';
part 'security.state.dart';

@riverpod
class SecurityController extends _$SecurityController with ConsoleMixin {
  @override
  SecurityState build() {
    postInit();
    return SecurityState.initial();
  }

  Future<void> postInit() async {
    await refreshState();
    console.info("⚙️ Initialize");
  }

  Future<void> set(BuildContext context, {required LockType type}) async {
    final securityService = ref.read(securityServiceProvider);
    await securityService.set(context: context, type: type);
    await refreshState();
  }

  Future<void> remove(BuildContext context, {required LockType type}) async {
    final securityService = ref.read(securityServiceProvider);
    await securityService.remove(context: context, type: type);
    await refreshState();
  }

  Future<void> refreshState() async {
    final securityService = ref.read(securityServiceProvider);
    LockType lockType = await securityService.getLock();
    state = state.copyWith(
      isEnabled: lockType != LockType.none,
      hasBiometrics: securityService.lockInfo.hasLocalAuth,
      biometrics: lockType == LockType.biometrics,
    );
  }
}
