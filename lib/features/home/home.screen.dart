// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/home/widgets/progress.widget.dart';
import 'package:authenticator/gen/assets.gen.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';
import 'package:authenticator/widgets/app_pop_button.dart';
import 'package:authenticator/widgets/item/item.card.widget.dart';
import 'package:authenticator/widgets/svg.loader.dart';

class EntryOverviewPage extends HookConsumerWidget {
  const EntryOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(homeControllerProvider.notifier).get();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) {
            final selected = ref.watch(
                homeControllerProvider.select((state) => state.selected));
            return MorphingAppBar(
              leading: selected.isNotEmpty
                  ? AppPopButton(
                      forceCloseButton: true,
                      tooltip: "Clear",
                      onPressed: () => ref
                          .read(homeControllerProvider.notifier)
                          .clearSelected())
                  : null,
              title: const AppBarTitle(fallbackRouter: AppRouter.home),
              actions: [
                AppCrossFade(
                  firstChild: const SizedBox(height: 48),
                  secondChild: IconButton(
                    onPressed: () async {
                      ref.read(homeControllerProvider.notifier).clearSelected();
                      await Navigator.of(context).pushNamed(
                          AppRouter.details.path,
                          arguments: DetailPageArgs(item: selected.first));
                      if (context.mounted) {
                        ref.read(homeControllerProvider.notifier).get();
                      }
                    },
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: "Edit",
                  ),
                  showFirst: selected.isEmpty || selected.length != 1,
                ),
                AppCrossFade(
                  firstChild: const SizedBox(height: 48),
                  secondChild: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                              AppRouter.transfer.path,
                              arguments: TransferPageArgs(
                                items:
                                    ref.read(homeControllerProvider).selected,
                              ));
                          if (context.mounted) {
                            ref
                                .read(homeControllerProvider.notifier)
                                .clearSelected();
                            ref.read(homeControllerProvider.notifier).get();
                          }
                        },
                        icon: const Icon(Icons.share_rounded),
                        tooltip: "Transfer",
                      ),
                      IconButton(
                        onPressed: () async {
                          await AppDialogs.showDeletionDialog(
                              context, selected, ref);
                          if (context.mounted) {
                            ref
                                .read(homeControllerProvider.notifier)
                                .clearSelected();
                            ref.read(homeControllerProvider.notifier).get();
                          }
                        },
                        icon: const Icon(Icons.delete_rounded),
                        tooltip: "Delete",
                      ),
                    ],
                  ),
                  showFirst: selected.isEmpty,
                ),
                PopupMenuButton<int>(
                  tooltip: "More",
                  icon: const Icon(Icons.more_vert_rounded),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Text("Settings"),
                    )
                  ],
                  onSelected: (value) async {
                    if (value == 0) {
                      await Navigator.of(context)
                          .pushNamed(AppRouter.settings.path);
                      ref.read(homeControllerProvider.notifier).get();
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          final entries = ref
              .watch(homeControllerProvider.select((state) => state.entries));
          return Column(
            children: [
              AnimatedOpacity(
                duration: Durations.short4,
                opacity: entries.isEmpty ? 0 : 1,
                child: const ProgressBar(),
              ),
              Expanded(
                child: entries.isEmpty
                    ? SvgLoader(svgPath: Assets.empty.path)
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final item = entries[index];
                          return ItemCard(index: index, item: item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        onPressed: () async => showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    key: const Key("home.fab.add.qr"),
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(AppRouter.scan.path);
                    },
                    leading: const Icon(Icons.qr_code_scanner_rounded),
                    title: const Text("Scan QR Code"),
                    shape: RoundedRectangleBorder(borderRadius: Shape.full),
                  ),
                  ListTile(
                    key: const Key("home.fab.add.image"),
                    onTap: () async {
                      Navigator.of(context).pop();
                      ref
                          .read(homeControllerProvider.notifier)
                          .pickAndScan(context);
                    },
                    leading: const Icon(Icons.add_photo_alternate_rounded),
                    title: const Text("Scan Image"),
                    shape: RoundedRectangleBorder(borderRadius: Shape.full),
                  ),
                  ListTile(
                    key: const Key("home.fab.add.manual"),
                    onTap: () async {
                      await Navigator.of(context).popAndPushNamed(
                          AppRouter.details.path,
                          arguments: const DetailPageArgs(item: null));
                      if (context.mounted) {
                        ref.read(homeControllerProvider.notifier).get();
                      }
                    },
                    leading: const Icon(Icons.edit_rounded),
                    title: const Text("Enter Manually"),
                    shape: RoundedRectangleBorder(borderRadius: Shape.full),
                  ),
                  ListTile(
                    key: const Key("home.fab.add.url"),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await ref
                          .read(homeControllerProvider.notifier)
                          .showManualUri(context);
                    },
                    leading: const Icon(Icons.edit_rounded),
                    title: const Text("Using URL (Advanced)"),
                    shape: RoundedRectangleBorder(borderRadius: Shape.full),
                  ),
                ],
              ),
            );
          },
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
