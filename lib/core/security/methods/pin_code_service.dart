part of '../security_service.dart';

class PinCodeService extends _BaseLockService<PinCodeOptions> {
  PinCodeService(this.info);

  final SecurityInformations info;

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
      onCancelled: Navigator.of(option.context).pop,
      canCancel: option.canCancel,
    ) as String?;
    if (matchedSecret != null) {
      await info.storage
          .setLock(type: option.nextLockType, secret: matchedSecret);
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
      title: "Remove Lock",
      canCancel: option.canCancel,
    );
    if (authenticated) await info.storage.setLock(type: option.nextLockType);
    return option.next(authenticated);
  }

  Future<bool> _confirmOwnership({
    required BuildContext context,
    required String secret,
    String? title,
    bool canCancel = false,
  }) async {
    final authenticated = await showEnhancedScreenLock(
      context: context,
      correctString: secret,
      title: Text(
        title ?? 'Unlock',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      canCancel: canCancel,
      onCancelled: () => Navigator.of(context).pop(false),
      onUnlocked: () => Navigator.of(context).pop(true),
    ) as bool?;
    return authenticated ?? false;
  }
}
