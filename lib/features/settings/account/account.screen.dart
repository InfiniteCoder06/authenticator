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
      accountControllerProvider.select(
        (state) => (state.syncingState, state.errorMessage),
      ),
      (prev, next) async {
        switch (next.$1) {
          case SyncingState.syncing:
            LoadingOverlay.of(context).show();
            break;
          case SyncingState.success:
            LoadingOverlay.of(context).hide();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text("Successfully Synced")),
              );
            break;
          case SyncingState.error:
            LoadingOverlay.of(context).hide();
            await AppDialogs.showErrorDialog(context, next.$2);
            break;
          case SyncingState.idle:
            break;
        }
      },
    );
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (didPop) return;
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            leading: const Icon(Icons.account_circle_rounded),
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
                            key: const Key("settings.list.smartSync"),
                            leading: const Icon(Icons.refresh_rounded),
                            title: const Text("Sync Changes"),
                            onTap: () async {
                              await ref
                                  .read(accountControllerProvider.notifier)
                                  .syncChanges(userId);
                            },
                          ),
                          ListTile(
                            key: const Key("settings.list.backup"),
                            leading: const Icon(Icons.cloud_upload_rounded),
                            title: const Text("Backup"),
                            onTap: () async {
                              if (ref
                                  .read(accountControllerProvider)
                                  .isSyncRequired) {
                                await ref
                                    .read(accountControllerProvider.notifier)
                                    .backupDataManual();
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                        content: Text("Nothing to Sync")),
                                  );
                              }
                            },
                          ),
                          ListTile(
                            key: const Key("settings.list.restore"),
                            leading: const Icon(Icons.cloud_download_rounded),
                            title: const Text("Restore"),
                            onTap: () async {
                              await ref
                                  .read(accountControllerProvider.notifier)
                                  .restoreData(userId, logging: true);
                            },
                          ),
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
