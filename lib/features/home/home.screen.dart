// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/local_auth/app_local_auth.widget.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/core/utils/qr.util.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/home/widgets/home.bottom_sheet.dart';
import 'package:authenticator/features/home/widgets/progress.widget.dart';
import 'package:authenticator/features/settings/security/security.controller.dart';
import 'package:authenticator/gen/assets.gen.dart';
import 'package:authenticator/modules.dart';
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
    final searchController = useTextEditingController();
    ref.listen(showSearchProvider, (prev, next) {
      if (!next) {
        FocusManager.instance.primaryFocus?.unfocus();
        searchController.clear();
      }
    });
    useListenable(searchController);
    useEffect(() {
      ref.read(getAllItemProvider);
      return null;
    }, []);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) {
            final selected = ref.watch(selectedEntriesProvider);
            final hasLock = ref.watch(
                securityControllerProvider.select((state) => state.isEnabled));
            return MorphingAppBar(
              leading: selected.isNotEmpty
                  ? AppPopButton(
                      forceCloseButton: true,
                      tooltip: "Clear",
                      onPressed: ref
                          .read(selectedEntriesProvider.notifier)
                          .clearSelected,
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
                      await Navigator.of(context).pushNamed(
                          AppRouter.details.path,
                          arguments: DetailPageArgs(item: selected.first));
                      ref
                          .read(selectedEntriesProvider.notifier)
                          .clearSelected();
                      ref.invalidate(getAllItemProvider);
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
                          await Navigator.of(context)
                              .pushNamed(AppRouter.transfer.path,
                                  arguments: TransferPageArgs(
                                    items: selected,
                                  ));
                          ref
                              .read(selectedEntriesProvider.notifier)
                              .clearSelected();
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
                            ref
                                .read(selectedEntriesProvider.notifier)
                                .clearSelected();
                            ref.invalidate(getAllItemProvider);
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
                      await Navigator.of(context)
                          .pushNamed(AppRouter.settings.path);
                      ref.invalidate(getAllItemProvider);
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
          final showSearch = ref.watch(showSearchProvider);
          final entries =
              ref.watch(filteredItemsProvider(searchController.text));
          return Column(
            children: [
              AnimatedOpacity(
                duration: Durations.short4,
                opacity: entries.isEmpty ? 0 : 1,
                child: const ProgressBar(),
              ),
              AppCrossFade(
                duration: Durations.medium2,
                showFirst: !showSearch,
                curve: Curves.fastOutSlowIn,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 2),
                  child: SearchBar(
                    hintText: 'Search',
                    controller: searchController,
                    elevation: const WidgetStatePropertyAll(1),
                    trailing: [
                      IconButton(
                        onPressed: () {
                          ref.read(showSearchProvider.notifier).state = false;
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? SvgLoader(svgPath: Assets.empty.path)
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final item = entries[index];
                          final selected = ref.watch(selectedEntriesProvider);
                          return ItemCard(
                            index: index,
                            item: item,
                            onDelete: (_) async {
                              await AppDialogs.showDeletionDialog(
                                  context, [item], ref);
                              ref.invalidate(getAllItemProvider);
                            },
                            onEdit: (_) async {
                              ref.read(showSearchProvider.notifier).state =
                                  false;
                              await Navigator.of(context).pushNamed(
                                  AppRouter.details.path,
                                  arguments: DetailPageArgs(item: item));
                              ref.invalidate(getAllItemProvider);
                            },
                            onLongPress: () {
                              if (selected.isEmpty) {
                                ref
                                    .read(selectedEntriesProvider.notifier)
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
                                              .read(selectedEntriesProvider
                                                  .notifier)
                                              .removeSelected(item)
                                          : ref
                                              .read(selectedEntriesProvider
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
              onAddQrPressed: () async {
                if (!Platform.isAndroid) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text("To Be Implemented")));
                } else {
                  await Navigator.of(context)
                      .popAndPushNamed(AppRouter.scan.path);
                  ref.invalidate(getAllItemProvider);
                }
              },
              onAddImagePressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await ref
                    .read(imagePickerProvider)
                    .pickImage(source: ImageSource.gallery);

                if (pickedFile == null) {
                  if (context.mounted) {
                    AppDialogs.showErrorDialog(
                        context, "User Cancelled Picker");
                  }
                  return;
                }

                final data = await pickedFile.readAsBytes();

                final result = await QrUtils().decodeFile(data);

                if (result.isNone() && context.mounted) {
                  AppDialogs.showErrorDialog(context, "QR not Found");
                  return;
                }

                final parseResult =
                    OtpUtils.parseURI(Uri.parse(result.toNullable()!.text));

                parseResult.fold(
                    (text) => AppDialogs.showErrorDialog(context, text),
                    (item) => Navigator.of(context).pushReplacementNamed(
                        AppRouter.details.path,
                        arguments: DetailPageArgs(item: item)));
              },
              onAddManualPressed: () async {
                await Navigator.of(context).popAndPushNamed(
                    AppRouter.details.path,
                    arguments: const DetailPageArgs(item: null));
                if (context.mounted) {
                  ref.invalidate(getAllItemProvider);
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
