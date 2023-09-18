// 🐦 Flutter imports:
import 'package:authenticator/widgets/loader.overlay.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/features/settings/account/account.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';
import 'package:authenticator/widgets/dropdown_list_tile.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.ref.watch(accountController.select((state) => state.isSyncing),
        listener: (prev, next) {
      if (!prev.isSyncing && next.isSyncing) {
        LoadingOverlay.of(context).show();
      }
      if (prev.isSyncing && !next.isSyncing) {
        LoadingOverlay.of(context).hide();
      }
    });
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
                    final cloudUpdated = context.ref.watch(
                        accountController.select((state) => state.lastSync));
                    return Center(
                      child: Text(
                        "Last Synced: ${DateTime.fromMillisecondsSinceEpoch(cloudUpdated).toIso8601String()}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }),
                  Builder(builder: (context) {
                    final userId = context.ref.watch(
                        accountController.select((state) => state.userId));
                    return Column(
                      children: [
                        MaterialDropDownListTile(
                          title: const Text("Account"),
                          subtitle: const Text("Select Account to sync"),
                          value: userId,
                          onChanged: (changedUser) async {
                            if (changedUser == null) return;
                            await context.ref
                                .notifier(accountController)
                                .syncChanges(changedUser, context);
                          },
                        ),
                        ListTile(
                          key: const Key("settings.list.security"),
                          leading: const Icon(Icons.refresh_rounded),
                          title: const Text("Sync Changes"),
                          onTap: () async {
                            await context.ref
                                .notifier(accountController)
                                .syncChanges(userId, context);
                          },
                        )
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
