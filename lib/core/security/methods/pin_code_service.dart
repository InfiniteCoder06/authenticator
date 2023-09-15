part of security_service;

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
    final matchedSecret = await showEnhancedCreateScreenLock<String>(
      context: option.context,
      title: const Text("Set Pin Code"),
      onConfirmed: (matchedSecret) =>
          Navigator.of(option.context).pop(matchedSecret),
    );
    if (matchedSecret != null) {
      info.storage.setLock(option.lockType, matchedSecret);
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
    if (authenticated) await info.clear();
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
    );
    return authenticated == true;
  }
}
