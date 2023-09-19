// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/security/security_service.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/schedule.mixin.dart';
import 'package:authenticator/provider.dart';

class AppLocalAuth extends StatefulHookConsumerWidget {
  const AppLocalAuth({
    super.key,
    required this.child,
  });

  final Widget child;
  static AppLocalAuthState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppLocalAuthState>();
  }

  @override
  ConsumerState<AppLocalAuth> createState() => AppLocalAuthState();
}

class AppLocalAuthState extends ConsumerState<AppLocalAuth>
    with WidgetsBindingObserver, ScheduleMixin {
  late SecurityService service;
  bool hasPinLockScreenOnState = false;

  @override
  void initState() {
    super.initState();
    service = ref.read(securityServiceProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => showLock());
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> showLock() async {
    if (hasPinLockScreenOnState) return;
    hasPinLockScreenOnState = true;
    await service.showLockIfHas(context);
    hasPinLockScreenOnState = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.resumed:
        cancelTimer(const ValueKey("SecurityService"));
        break;
      case AppLifecycleState.paused:
        ref
            .read(securityStorageProvider)
            .get(kLockTimeout, defaultValue: 10)
            .then((e) {
          scheduleAction(
            () => showLock(),
            key: const ValueKey("SecurityService"),
            duration: Duration(seconds: e),
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
