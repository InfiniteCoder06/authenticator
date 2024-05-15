// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/features/settings/security/security.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';

class SecuritySettingsPage extends HookConsumerWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref
        .watch(securityControllerProvider.select((state) => state.isEnabled));
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverPadding(
            padding: ConfigConstant.layoutPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  SwitchListTile(
                    title: const Text('Security'),
                    subtitle: const Text('Enable security'),
                    value: isEnabled,
                    onChanged: (value) {
                      value
                          ? ref
                              .read(securityControllerProvider.notifier)
                              .set(context, type: LockType.pin)
                          : ref
                              .read(securityControllerProvider.notifier)
                              .remove(context, type: LockType.pin);
                    },
                  ),
                  if (isEnabled)
                    Builder(
                      builder: (context) {
                        final controller = ref.watch(
                            securityControllerProvider.select((state) =>
                                (state.hasBiometrics, state.biometrics)));
                        return SwitchListTile(
                          title: const Text('Biometric Unlock'),
                          subtitle: const Text(
                              'Allow biometric authentication to unlock'),
                          value: controller.$2,
                          onChanged: controller.$1
                              ? (value) {
                                  value
                                      ? ref
                                          .read(securityControllerProvider
                                              .notifier)
                                          .set(context,
                                              type: LockType.biometrics)
                                      : ref
                                          .read(securityControllerProvider
                                              .notifier)
                                          .remove(context,
                                              type: LockType.biometrics);
                                }
                              : null,
                        );
                      },
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
