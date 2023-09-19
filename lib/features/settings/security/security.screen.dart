// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/features/settings/security/security.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';
import 'package:authenticator/widgets/switch_list_tile.dart';

class SecuritySettingsPage extends HookConsumerWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Builder(
                  builder: (context) {
                    final controller = ref.watch(securityControllerProvider);
                    return MaterialSwitchListTile(
                      title: const Text('Security'),
                      subtitle: const Text('Enable security'),
                      value: controller,
                      onToggle: (bool value) {
                        value
                            ? ref
                                .read(securityControllerProvider.notifier)
                                .set(context, type: LockType.biometrics)
                            : ref
                                .read(securityControllerProvider.notifier)
                                .remove(context, type: LockType.biometrics);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
