// ignore_for_file: use_build_context_synchronously

library security_service;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

// 🌎 Project imports:
import 'package:authenticator/core/persistence/security.persistance.dart';
import 'package:authenticator/core/security/security_object.dart';
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/core/types/lock_flow.type.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/screen_lock/screen_lock.util.dart';
import 'package:authenticator/widgets/app.button.widget.dart';

part './methods/biometrics_service.dart';
part './methods/pin_code_service.dart';
part './helpers/security_information.dart';
part './methods/base_lock_service.dart';
part './helpers/options.dart';

class SecurityService {
  Future<void> initialize() => lockInfo.initialize();

  final SecurityInformations lockInfo;

  SecurityService({
    required this.lockInfo,
  });

  late final pinCodeService = PinCodeService(lockInfo);
  late final biometricService = BiometricsService(lockInfo);

  Future<bool> hasLock() async {
    SecurityObject object = await lockInfo.getLock();
    return object.type != LockType.none;
  }

  Future<LockType> getLock() async {
    SecurityObject object = await lockInfo.getLock();
    return object.type;
  }

  Future<bool> showLockIfHas(BuildContext context) async {
    SecurityObject object = await lockInfo.getLock();
    if (object.type == LockType.none) return true;
    return unlock(
      context: context,
    );
  }

  Future<bool> unlock({
    required BuildContext context,
  }) async {
    SecurityObject object = await lockInfo.getLock();
    switch (object.type) {
      case LockType.pin:
        return pinCodeService.unlock(PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          flowType: LockFlowType.unlock,
          next: (authenticated) async => authenticated,
        ));
      case LockType.biometrics:
        return biometricService.unlock(BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometrics,
          flowType: LockFlowType.unlock,
          next: (bool authenticated) async => authenticated,
        ));
      default:
        return true;
    }
  }

  Future<bool> set({
    required BuildContext context,
    required LockType type,
  }) async {
    switch (type) {
      case LockType.pin:
        return await pinCodeService.set(PinCodeOptions(
          context: context,
          object: null,
          lockType: LockType.pin,
          flowType: LockFlowType.set,
          next: (authenticated) async => authenticated,
        ));
      case LockType.biometrics:
        return await biometricService.set(BiometricsOptions(
          context: context,
          object: null,
          lockType: LockType.biometrics,
          flowType: LockFlowType.set,
          next: (authenticated) async => authenticated,
        ));
      default:
        return false;
    }
  }

  Future<bool> remove({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject object = await lockInfo.getLock();

    switch (type) {
      case LockType.pin:
        return pinCodeService.remove(PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.none,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async => authenticated,
        ));
      case LockType.biometrics:
        return biometricService.remove(BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async => authenticated,
        ));
      default:
        return true;
    }
  }
}
