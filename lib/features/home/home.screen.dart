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
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/core/utils/qr.util.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/home/widgets/home.appbar.dart';
import 'package:authenticator/features/home/widgets/home.bottom_sheet.dart';
import 'package:authenticator/features/home/widgets/home.info.dart';
import 'package:authenticator/features/home/widgets/home.search.dart';
import 'package:authenticator/features/home/widgets/progress.widget.dart';
import 'package:authenticator/gen/assets.gen.dart';
import 'package:authenticator/modules.dart';
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
    final searchNode = useFocusNode();
    ref.listen(showSearchProvider, (prev, next) async {
      if (!next) {
        FocusManager.instance.primaryFocus?.unfocus();
        searchController.clear();
      } else {
        await Future.delayed(Durations.medium3);
        searchNode.requestFocus();
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
          HomeSearchBar(
            focusNode: searchNode,
            searchController: searchController,
          ),
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
                          itemCount: entries.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const HomeInfoBar();
                            }
                            final item = entries[index - 1];
                            final selected = ref.watch(selectedEntriesProvider);
                            return ItemCard(
                              index: index - 1,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        onPressed: () async => showModalBottomSheet(
          context: context,
          showDragHandle: false,
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

                parseResult.fold(
                  (text) => AppDialogs.showErrorDialog(context, text),
                  (result) async {
                    var item = result.$1;
                    if (result.$2.length == 2) {
                      final selectedIssuer =
                          await AppDialogs.showSelectIssuerDialog(
                              context, result.$2);
                      item = item.copyWith(issuer: selectedIssuer);
                    }
                    if (!context.mounted) return;
                    await Navigator.of(context).pushNamed(
                      AppRouter.details.path,
                      arguments: DetailPageArgs(item: item, isUrl: true),
                    );
                  },
                );
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
