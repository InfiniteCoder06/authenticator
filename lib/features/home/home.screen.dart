// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/core/utils/qr.util.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/home/widgets/home.appbar.dart';
import 'package:authenticator/features/home/widgets/home.bottom_sheet.dart';
import 'package:authenticator/features/home/widgets/progress.widget.dart';
import 'package:authenticator/gen/assets.gen.dart';
import 'package:authenticator/modules.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';
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
      ref.read(showBackupNotiProvider);
      return null;
    }, []);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomeAppBar(),
      ),
      body: Column(
        children: [
          Builder(builder: (context) {
            final isEmpty =
                ref.watch(entriesProvider.select((list) => list.isEmpty));
            return AnimatedOpacity(
              duration: Durations.short4,
              opacity: isEmpty ? 0 : 1,
              child: const ProgressBar(),
            );
          }),
          Builder(
            builder: (context) {
              final showSearch = ref.watch(showSearchProvider);
              return AppCrossFade(
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
              );
            },
          ),
          Builder(builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            final show = ref.watch(showBackupBannerProvider);
            return AppCrossFade(
              firstChild: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
                child: Material(
                  color: colorScheme.errorContainer,
                  borderRadius: ShapeConstant.extraLarge,
                  child: InkWell(
                    borderRadius: ShapeConstant.extraLarge,
                    onTap: () async {
                      await Navigator.of(context)
                          .pushNamed(AppRouter.account.path);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: colorScheme.error,
                          ),
                          ConfigConstant.sizedBoxW1,
                          Text(
                            "Changes are not backed up",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              secondChild: const SizedBox.shrink(),
              showFirst: show,
            );
          }),
          Builder(
            builder: (context) {
              final entries =
                  ref.watch(filteredItemsProvider(searchController.text));
              return Expanded(
                child: entries.isEmpty
                    ? SvgLoader(svgPath: Assets.empty.path)
                    : RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(Durations.medium1);
                          return ref.refresh(getAllItemProvider.future);
                        },
                        child: ListView.builder(
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
                                ref
                                    .read(selectedEntriesProvider.notifier)
                                    .clearSelected();
                              },
                              onEdit: (_) async {
                                ref.read(showSearchProvider.notifier).state =
                                    false;
                                await Navigator.of(context).pushNamed(
                                    AppRouter.details.path,
                                    arguments: DetailPageArgs(
                                        item: item, isUrl: false));
                                ref
                                    .read(selectedEntriesProvider.notifier)
                                    .clearSelected();
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
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        onPressed: () async => showModalBottomSheet(
          context: context,
          showDragHandle: true,
          routeSettings: const RouteSettings(name: "HomeBottomSheet"),
          builder: (_) {
            return HomeBottomSheet(
              onAddQrPressed: () async {
                if (kIsWeb || !Platform.isAndroid) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(content: Text("To Be Implemented")));
                } else {
                  await Navigator.of(context)
                      .popAndPushNamed(AppRouter.scan.path);
                }
              },
              onAddImagePressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await ref
                    .read(imagePickerProvider)
                    .pickImage(source: ImageSource.gallery);

                if (pickedFile == null) {
                  if (!context.mounted) return;
                  AppDialogs.showErrorDialog(context, "User Cancelled Picker");
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

                parseResult
                    .fold((text) => AppDialogs.showErrorDialog(context, text),
                        (item) async {
                  await Navigator.of(context).pushNamed(
                      AppRouter.details.path,
                      arguments: DetailPageArgs(item: item, isUrl: true));
                });
              },
              onAddManualPressed: () async {
                await Navigator.of(context).popAndPushNamed(
                    AppRouter.details.path,
                    arguments: const DetailPageArgs(item: null, isUrl: false));
              },
            );
          },
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
