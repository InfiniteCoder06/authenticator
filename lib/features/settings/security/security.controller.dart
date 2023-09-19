// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'security.controller.g.dart';

@riverpod
class SecurityController extends _$SecurityController with ConsoleMixin {
  @override
  bool build() {
    postInit();
    return false;
  }

  Future<void> postInit() async {
    final securityService = ref.read(securityServiceProvider);
    state = await securityService.hasLock();
    console.info("⚙️ Initialize");
  }

  Future<void> set(BuildContext context, {required LockType type}) async {
    final securityService = ref.read(securityServiceProvider);
    await securityService.set(context: context, type: type);
    state = await securityService.hasLock();
  }

  Future<void> remove(BuildContext context, {required LockType type}) async {
    final securityService = ref.read(securityServiceProvider);
    await securityService.remove(context: context, type: type);
    state = await securityService.hasLock();
  }
}
