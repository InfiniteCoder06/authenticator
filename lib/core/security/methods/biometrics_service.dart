part of '../security_service.dart';

class BiometricsService extends _BaseLockService<BiometricsOptions>
    with ConsoleMixin {
  BiometricsService(this.info);

  final SecurityInformations info;

  @override
  Future<bool> unlock(BiometricsOptions option) async {
    assert(option.object != null);
    if (!info.hasLocalAuth) return true;

    bool authenticated = await showEnhancedScreenLock(
          context: option.context,
          correctString: option.object!.secret,
          customizedButtonChild: const Icon(Icons.fingerprint),
          onUnlocked: () => Navigator.of(option.context).pop(true),
          customizedButtonTap: () async {
            await _authentication(option.context, "Unlock")
                .then((authenticated) {
              if (authenticated && option.context.mounted) {
                Navigator.of(option.context).pop(true);
              }
            });
          },
          canCancel: option.canCancel,
          onOpened: () async {
            await _authentication(option.context, "Unlock")
                .then((authenticated) {
              if (authenticated && option.context.mounted) {
                Navigator.of(option.context).pop(true);
              }
            });
          },
        ) as bool? ??
        false;

    return option.next(authenticated);
  }

  @override
  Future<bool> set(BiometricsOptions option) async {
    bool authenticated =
        await _authentication(option.context, "Set up biometic unlock");
    if (authenticated) {
      await info.storage.setLock(type: option.nextLockType);
    }
    return option.next(authenticated);
  }

  @override
  Future<bool> remove(BiometricsOptions option) async {
    bool authenticated =
        await _authentication(option.context, "Remove biometric");
    if (authenticated) {
      await info.storage.setLock(type: option.nextLockType);
    }
    return option.next(authenticated);
  }

  Future<bool> _authentication(
    BuildContext context,
    String localizedReason,
  ) async {
    try {
      return info.localAuth.authenticate(localizedReason: localizedReason);
    } on PlatformException catch (e) {
      console.error("$e");
      if (e.code == auth_error.notAvailable) {
        AppDialogs.showErrorDialog(
          context,
          "This Device Does not support Biometrics",
          title: "Biometrics Not Available",
        );
      }
    }

    return false;
  }
}
