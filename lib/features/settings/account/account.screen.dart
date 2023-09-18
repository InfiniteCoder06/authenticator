// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/features/settings/account/account.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const AppExpandedAppBar(),
          SliverPadding(
            padding: ConfigConstant.layoutPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Builder(builder: (context) {
                    final cloudUpdated = context.ref.watch(accountController
                        .select((state) => state.cloudUpdated));
                    return Center(
                      child: Text(
                        "Last Synced: ${DateTime.fromMillisecondsSinceEpoch(cloudUpdated).toIso8601String()}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }),
                  ListTile(
                    key: const Key("settings.list.security"),
                    leading: const Icon(Icons.refresh_rounded),
                    title: const Text("Sync Changes"),
                    onTap: () async {
                      context.ref.notifier(accountController).syncChanges();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
