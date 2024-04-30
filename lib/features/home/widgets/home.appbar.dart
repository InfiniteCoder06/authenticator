// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/local_auth/app_local_auth.widget.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/settings/security/security.controller.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';
import 'package:authenticator/widgets/app_pop_button.dart';

class HomeAppBar extends HookConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedEntriesProvider);
    final hasLock = ref
        .watch(securityControllerProvider.select((state) => state.isEnabled));
    return MorphingAppBar(
      leading: selected.isNotEmpty
          ? AppPopButton(
              forceCloseButton: true,
              tooltip: "Clear",
              onPressed:
                  ref.read(selectedEntriesProvider.notifier).clearSelected,
            )
          : null,
      title: const AppBarTitle(fallbackRouter: AppRouter.home),
      actions: [
        AppCrossFade(
          showFirst: selected.isEmpty || selected.length != 1,
          firstChild: const SizedBox(height: 48),
          secondChild: IconButton(
            onPressed: () async {
              ref.read(showSearchProvider.notifier).state = false;
              await Navigator.of(context).pushNamed(AppRouter.details.path,
                  arguments:
                      DetailPageArgs(item: selected.first, isUrl: false));
              ref.read(selectedEntriesProvider.notifier).clearSelected();
            },
            icon: const Icon(Icons.edit_rounded),
            tooltip: "Edit",
          ),
        ),
        AppCrossFade(
          showFirst: selected.isEmpty,
          firstChild: IconButton(
            onPressed: () async {
              ref.read(showSearchProvider.notifier).state = true;
            },
            icon: const Icon(Icons.search_rounded),
            tooltip: "Search",
          ),
          secondChild: Row(
            children: [
              IconButton(
                onPressed: () async {
                  ref.read(showSearchProvider.notifier).state = false;
                  await Navigator.of(context).pushNamed(AppRouter.transfer.path,
                      arguments: TransferPageArgs(
                        items: selected,
                      ));
                  ref.read(selectedEntriesProvider.notifier).clearSelected();
                },
                icon: const Icon(Icons.share_rounded),
                tooltip: "Transfer",
              ),
              IconButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  bool hasDeleted = await AppDialogs.showDeletionDialog(
                      context, selected, ref);
                  if (hasDeleted) {
                    ref.read(selectedEntriesProvider.notifier).clearSelected();
                    ref.refresh(getAllItemProvider);
                  }
                },
                icon: const Icon(Icons.delete_rounded),
                tooltip: "Delete",
              ),
            ],
          ),
        ),
        PopupMenuButton<int>(
          tooltip: "More",
          icon: const Icon(Icons.more_vert_rounded),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0,
              child: Text("Settings"),
            ),
            if (hasLock)
              const PopupMenuItem(
                value: 1,
                child: Text("Lock"),
              )
          ],
          onSelected: (value) async {
            if (value == 0) {
              ref.read(showSearchProvider.notifier).state = false;
              await Navigator.of(context).pushNamed(AppRouter.settings.path);
              ref.refresh(getAllItemProvider);
            }
            if (value == 1) {
              if (!context.mounted) return;
              AppLocalAuth.of(context)?.showLock();
            }
          },
        ),
      ],
    );
  }
}
