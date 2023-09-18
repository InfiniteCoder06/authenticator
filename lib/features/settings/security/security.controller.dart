// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpie/riverpie.dart';

// 🌎 Project imports:
import 'package:authenticator/core/security/security_service.dart';
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

final securityController = NotifierProvider<SecurityController, bool>(
    (ref) => SecurityController(ref.read(securityServiceProvider)));

class SecurityController extends PureNotifier<bool> with ConsoleMixin {
  SecurityController(this.securityService);

  final SecurityService securityService;

  @override
  bool init() => false;

  @override
  Future<void> postInit() async {
    state = await securityService.hasLock();
    console.info("⚙️ Initialize");
  }

  Future<void> set(BuildContext context, {required LockType type}) async {
    await securityService.set(context: context, type: type);
    state = await securityService.hasLock();
  }

  Future<void> remove(BuildContext context, {required LockType type}) async {
    await securityService.remove(context: context, type: type);
    state = await securityService.hasLock();
  }
}
