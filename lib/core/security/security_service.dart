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
import 'package:authenticator/core/utils/extension/color_scheme.extension.dart';
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

  Future<bool> showLockIfHas(
    BuildContext context, {
    LockFlowType flowType = LockFlowType.unlock,
  }) async {
    SecurityObject object = await lockInfo.getLock();
    if (object.type == LockType.none) return true;
    return unlock(
      context: context,
      flowType: flowType,
    );
  }

  Future<bool> unlock({
    required BuildContext context,
    LockFlowType flowType = LockFlowType.unlock,
  }) async {
    SecurityObject object = await lockInfo.getLock();
    switch (object.type) {
      case LockType.pin:
        return pinCodeService.unlock(PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          flowType: flowType,
          next: (authenticated) async => authenticated,
        ));
      case LockType.biometrics:
        return biometricService.unlock(BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometrics,
          flowType: flowType,
          next: (bool authenticated) async => authenticated,
        ));
      default:
        return true;
    }
  }

  Future<void> set({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject object = await lockInfo.getLock();
    if (object.type != LockType.none) {
      return update(context: context, type: type);
    }

    switch (type) {
      case LockType.pin:
        await pinCodeService.set(PinCodeOptions(
          context: context,
          object: null,
          lockType: LockType.pin,
          flowType: LockFlowType.set,
          next: (authenticated) async => authenticated,
        ));
        break;
      case LockType.biometrics:
        await biometricService.set(BiometricsOptions(
          context: context,
          object: null,
          lockType: LockType.biometrics,
          flowType: LockFlowType.set,
          next: (authenticated) async {
            if (authenticated) {
              return pinCodeService.set(PinCodeOptions(
                context: context,
                object: null,
                lockType: LockType.biometrics,
                flowType: LockFlowType.set,
                next: (bool authenticated) async => authenticated,
              ));
            } else {
              return authenticated;
            }
          },
        ));
      default:
        break;
    }
  }

  /// NOTE: no need to update for biometric
  // to update: unlock -> remove -> set
  Future<void> update({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject object = await lockInfo.getLock();
    if (object.type == LockType.none) return;
    await remove(context: context, type: object.type);

    // make sure object = null before call set
    SecurityObject removedObject = await lockInfo.getLock();
    if (removedObject.type == LockType.none) {
      await set(context: context, type: type);

      // in case it fail, we set lock
      SecurityObject setObject = await lockInfo.getLock();
      if (setObject.type == LockType.none) {
        lockInfo.storage.setLock(object.type, object.secret);
      }
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
          lockType: LockType.pin,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async => authenticated,
        ));
      case LockType.biometrics:
        return biometricService.remove(BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometrics,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async {
            if (!authenticated) {
              bool authenticatedFromPin =
                  await pinCodeService.unlock(PinCodeOptions(
                context: context,
                object: null,
                lockType: LockType.biometrics,
                flowType: LockFlowType.remove,
                next: (bool authenticated) async => authenticated,
              ));
              if (authenticatedFromPin) await lockInfo.clear();
              return authenticatedFromPin;
            } else {
              return authenticated;
            }
          },
        ));
      default:
        return true;
    }
  }
}
