part of '../security_service.dart';

class BiometricsService extends _BaseLockService<BiometricsOptions>
    with ConsoleMixin {
  final SecurityInformations info;
  BiometricsService(this.info);

  @override
  Future<bool> unlock(BiometricsOptions option) async {
    assert(option.object != null);
    if (!info.hasLocalAuth) return true;

    bool authenticated = await showEnhancedScreenLock(
          context: option.context,
          correctString: option.object!.secret,
          customizedButtonChild: const Icon(Icons.fingerprint),
          footer: buildFooter(option.context),
          onUnlocked: () => Navigator.of(option.context).pop(true),
          customizedButtonTap: () async {
            await _authentication(option.context, "Unlock")
                .then((authenticated) {
              if (authenticated) Navigator.of(option.context).pop(true);
            });
          },
          canCancel: option.canCancel,
          onOpened: () async {
            await _authentication(option.context, "Unlock")
                .then((authenticated) {
              if (authenticated) Navigator.of(option.context).pop(true);
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
    return option.next(authenticated);
  }

  @override
  Future<bool> remove(BiometricsOptions option) async {
    bool authenticated =
        await _authentication(option.context, "Remove biometric");
    if (authenticated) await info.clear();
    return option.next(authenticated);
  }

  Future<bool> _authentication(
    BuildContext context,
    String localizedReason,
  ) async {
    try {
      return info.localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      console.error("$e");
      if (e.code == auth_error.notAvailable) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Biometrics Not Available"),
              content: const Text("This Device Does not support Biometrics"),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("Ok"),
                )
              ],
            );
          },
        );
      }
    }

    return false;
  }
}
