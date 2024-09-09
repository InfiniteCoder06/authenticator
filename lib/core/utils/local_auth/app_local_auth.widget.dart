// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/security/security_service.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/schedule.mixin.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/core/utils/share.service.dart';
import 'package:authenticator/provider.dart';

class AppLocalAuth extends StatefulHookConsumerWidget {
  const AppLocalAuth({
    super.key,
    required this.navKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navKey;
  final Widget child;
  static AppLocalAuthState? of(BuildContext context) =>
      context.findAncestorStateOfType<AppLocalAuthState>();

  @override
  ConsumerState<AppLocalAuth> createState() => AppLocalAuthState();
}

class AppLocalAuthState extends ConsumerState<AppLocalAuth>
    with WidgetsBindingObserver, ScheduleMixin {
  late SecurityService service;
  int lockTime = 10;
  bool hasPinLockScreenOnState = false;

  @override
  void initState() {
    super.initState();
    service = ref.read(securityServiceProvider);
    ref
        .read(securityStorageProvider)
        .get(kLockTimeout, defaultValue: 10)
        .then((value) => lockTime = value);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showLock();
      ShareService()
        ..onDataReceived = _handleSharedData
        ..getSharedData().then(_handleSharedData);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _handleSharedData(String sharedData) async {
    if (sharedData.isNotEmpty) {
      final result = OtpUtils.parseURI(Uri.parse(sharedData));
      result.match((error) => AppDialogs.showErrorDialog(context, error),
          (result) async {
        var item = result.$1;
        if (result.$2.length == 2) {
          final selectedIssuer =
              await AppDialogs.showSelectIssuerDialog(context, result.$2);
          item = item.copyWith(issuer: selectedIssuer);
        }
        Navigator.of(widget.navKey.currentContext!).pushNamed(
          AppRouter.details.path,
          arguments: DetailPageArgs(item: item, isUrl: true),
        );
      });
    }
  }

  Future<void> showLock() async {
    if (hasPinLockScreenOnState) return;
    hasPinLockScreenOnState = true;
    await service.showLockIfHas(widget.navKey.currentContext!);
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
      case AppLifecycleState.paused:
        scheduleAction(
          showLock,
          key: const ValueKey("SecurityService"),
          duration: Duration(seconds: lockTime),
        );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
