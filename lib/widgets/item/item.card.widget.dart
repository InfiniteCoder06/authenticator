// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/core/utils/utils.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';
import 'package:authenticator/widgets/item/custom.list.widget.dart';
import 'package:authenticator/widgets/item/item.body.widget.dart';
import 'package:authenticator/widgets/item/item.header.widget.dart';
import 'package:authenticator/widgets/item/item.otp.widget.dart';
import 'package:authenticator/widgets/item/item.wrapper.widget.dart';

class ItemCard extends HookWidget {
  const ItemCard({
    required this.index,
    required this.item,
    super.key,
  });
  final Item item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final hasTapped = useValueNotifier(false);
    return ValueListenableBuilder(
      valueListenable: hasTapped,
      builder: (context, tap, child) {
        return Builder(builder: (context) {
          final selected = context.ref
              .watch(homeController.select((state) => state.selected));
          return CustomList(
            index,
            onPress: () async {
              final copyOnTap = context.ref.read(behaviorController).copyOnTap;
              if (selected.isNotEmpty) {
                final bool inList = selected.contains(item);
                inList
                    ? context.ref.notifier(homeController).removeSelected(item)
                    : context.ref.notifier(homeController).addSelected(item);
              } else if (!tap && copyOnTap) {
                hasTapped.value = true;
                await AppUtils.copyToClipboard(item.getOTP());
                Future<void>.delayed(const Duration(seconds: 2), () {
                  hasTapped.value = false;
                });
              }
            },
            onLongPress: () {
              if (selected.isEmpty) {
                context.ref.notifier(homeController).addSelected(item);
              }
            },
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                child: Row(
                  children: <Widget>[
                    ItemAvatar(
                      item: item,
                      selected: selected.contains(item),
                      onAvatarPress: () {
                        final bool inList = selected.contains(item);
                        inList
                            ? context.ref
                                .notifier(homeController)
                                .removeSelected(item)
                            : context.ref
                                .notifier(homeController)
                                .addSelected(item);
                      },
                    ),
                    ConfigConstant.sizedBoxW2,
                    ItemWidgetWrapper(
                      ItemBody(item),
                      otp: ItemOTP(
                        item,
                        selected: selected.contains(item),
                        copied: tap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
