part of '../security_service.dart';

class PinCodeService extends _BaseLockService<PinCodeOptions> {
  final SecurityInformations info;
  PinCodeService(this.info);

  @override
  Future<bool> unlock(PinCodeOptions option) async {
    assert(option.object != null);

    bool authenticated = await _confirmOwnership(
      context: option.context,
      secret: option.object!.secret,
      canCancel: option.canCancel,
    );

    return option.next(authenticated);
  }

  @override
  Future<bool> set(PinCodeOptions option) async {
    final matchedSecret = await showEnhancedCreateScreenLock(
      context: option.context,
      onConfirmed: (matchedSecret) {
        Navigator.of(option.context).pop(matchedSecret);
      },
      canCancel: option.canCancel,
    ) as String?;
    if (matchedSecret != null) {
      info.storage.setLock(type: option.lockType, secret: matchedSecret);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> remove(PinCodeOptions option) async {
    assert(option.object != null);
    bool authenticated = await _confirmOwnership(
      context: option.context,
      secret: option.object!.secret,
      canCancel: option.canCancel,
    );
    if (authenticated) info.storage.setLock(type: option.lockType);
    return option.next(authenticated);
  }

  Future<bool> _confirmOwnership({
    required BuildContext context,
    required String secret,
    bool canCancel = false,
  }) async {
    final authenticated = await showEnhancedScreenLock(
      context: context,
      correctString: secret,
      canCancel: canCancel,
      footer: buildFooter(context),
      onUnlocked: () => Navigator.of(context).pop(true),
    ) as bool;
    return authenticated == true;
  }
}
