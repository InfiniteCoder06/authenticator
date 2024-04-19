// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/local_auth/app_local_auth.widget.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/home/widgets/home.bottom_sheet.dart';
import 'package:authenticator/features/home/widgets/progress.widget.dart';
import 'package:authenticator/features/settings/security/security.controller.dart';
import 'package:authenticator/gen/assets.gen.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';
import 'package:authenticator/widgets/app_pop_button.dart';
import 'package:authenticator/widgets/item/item.body.widget.dart';
import 'package:authenticator/widgets/item/item.card.widget.dart';
import 'package:authenticator/widgets/item/item.header.widget.dart';
import 'package:authenticator/widgets/item/item.otp.widget.dart';
import 'package:authenticator/widgets/item/item.wrapper.widget.dart';
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
            final hasLock = ref.watch(securityControllerProvider);
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
                  showFirst: selected.isEmpty || selected.length != 1,
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
                ),
                AppCrossFade(
                  showFirst: selected.isEmpty,
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
                      await Navigator.of(context)
                          .pushNamed(AppRouter.settings.path);
                      ref.read(homeControllerProvider.notifier).get();
                    }
                    if (value == 1) {
                      if (!context.mounted) return;
                      AppLocalAuth.of(context)?.showLock();
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
                          final selected = ref.watch(homeControllerProvider
                              .select((state) => state.selected));
                          return ItemCard(
                            index: index,
                            item: item,
                            onDelete: (_) async {
                              await AppDialogs.showDeletionDialog(
                                  context, [item], ref);
                              ref.read(homeControllerProvider.notifier).get();
                            },
                            onEdit: (_) async {
                              await Navigator.of(context).pushNamed(
                                  AppRouter.details.path,
                                  arguments: DetailPageArgs(item: item));
                              if (context.mounted) {
                                ref.read(homeControllerProvider.notifier).get();
                              }
                            },
                            onLongPress: () {
                              if (selected.isEmpty) {
                                ref
                                    .read(homeControllerProvider.notifier)
                                    .addSelected(item);
                              }
                            },
                            builder: (tap) {
                              return Row(
                                children: [
                                  ItemAvatar(
                                    item: item,
                                    selected: selected.contains(item),
                                    onAvatarPress: () {
                                      final bool inList =
                                          selected.contains(item);
                                      inList
                                          ? ref
                                              .read(homeControllerProvider
                                                  .notifier)
                                              .removeSelected(item)
                                          : ref
                                              .read(homeControllerProvider
                                                  .notifier)
                                              .addSelected(item);
                                    },
                                  ),
                                  ConfigConstant.sizedBoxW2,
                                  ItemWidgetWrapper(
                                    ItemBody(item),
                                    otp: ItemOTP(
                                      item,
                                      copied: tap,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
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
            return HomeBottomSheet(
              onAddQrPressed: () {
                if (!Platform.isAndroid) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text("To Be Implemented")));
                } else {
                  Navigator.of(context).popAndPushNamed(AppRouter.scan.path);
                }
              },
              onAddImagePressed: () {
                Navigator.of(context).pop();
                ref.read(homeControllerProvider.notifier).pickAndScan(context);
              },
              onAddManualPressed: () async {
                await Navigator.of(context).popAndPushNamed(
                    AppRouter.details.path,
                    arguments: const DetailPageArgs(item: null));
                if (context.mounted) {
                  ref.read(homeControllerProvider.notifier).get();
                }
              },
            );
          },
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
