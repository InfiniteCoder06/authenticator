// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/features/settings/account/account.controller.dart';
import 'package:authenticator/widgets/app_silver_app_bar.dart';
import 'package:authenticator/widgets/dropdown_list_tile.dart';
import 'package:authenticator/widgets/loader.overlay.dart';

class AccountSettingsPage extends HookConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
        accountControllerProvider
            .select((state) => (state.syncingState, state.errorMessage)),
        (prev, next) async {
      if (next.$1 == SyncingState.syncing) {
        LoadingOverlay.of(context).show();
      }
      if (next.$1 == SyncingState.success) {
        LoadingOverlay.of(context).hide();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text("Successfully Synced")),
          );
      }
      if (next.$1 == SyncingState.error) {
        LoadingOverlay.of(context).hide();
        await AppDialogs.showErrorDialog(context, next.$2);
      }
    });
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            const AppExpandedAppBar(),
            SliverPadding(
              padding: ConfigConstant.layoutPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Builder(builder: (context) {
                      final cloudUpdated = ref.watch(accountControllerProvider
                          .select((state) => state.lastSync));
                      return Center(
                        child: Text(
                          "Last Synced: ${DateTime.fromMillisecondsSinceEpoch(cloudUpdated).toIso8601String()}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      final userId = ref.watch(accountControllerProvider
                          .select((state) => state.userId));
                      return Column(
                        children: [
                          MaterialDropDownListTile(
                            title: const Text("Account"),
                            subtitle: const Text("Select Account to sync"),
                            value: userId,
                            onChanged: (changedUser) async {
                              if (changedUser == null) return;
                              await ref
                                  .read(accountControllerProvider.notifier)
                                  .syncChanges(changedUser);
                            },
                          ),
                          ListTile(
                            key: const Key("settings.list.security"),
                            leading: const Icon(Icons.refresh_rounded),
                            title: const Text("Sync Changes"),
                            onTap: () async {
                              await ref
                                  .read(accountControllerProvider.notifier)
                                  .syncChanges(userId);
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
      ),
    );
  }
}
