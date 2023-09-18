// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/features/settings/security/security.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';
import 'package:authenticator/widgets/switch_list_tile.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Builder(
                  builder: (context) {
                    final controller = context.ref.watch(securityController);
                    return MaterialSwitchListTile(
                      title: const Text('Security'),
                      subtitle: const Text('Enable security'),
                      value: controller,
                      onToggle: (bool value) {
                        value
                            ? context.ref
                                .notifier(securityController)
                                .set(context, type: LockType.biometrics)
                            : context.ref
                                .notifier(securityController)
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
