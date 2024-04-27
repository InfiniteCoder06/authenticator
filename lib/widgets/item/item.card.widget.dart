// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/core/utils/utils.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';

class ItemCard extends HookConsumerWidget {
  const ItemCard({
    required this.index,
    required this.item,
    this.onPress,
    this.onDelete,
    this.onEdit,
    this.onLongPress,
    required this.builder,
    super.key,
  });
  final Item item;
  final int index;
  final void Function(bool value)? onPress;
  final void Function(BuildContext context)? onDelete;
  final void Function(BuildContext context)? onEdit;
  final void Function()? onLongPress;
  final Widget Function(bool value) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasTapped = useValueNotifier(false);
    return ValueListenableBuilder(
      valueListenable: hasTapped,
      builder: (context, tap, child) {
        return Builder(builder: (context) {
          final selected = ref.watch(selectedEntriesProvider);
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: Durations.short2,
            child: SlideAnimation(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              child: FadeInAnimation(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: ShapeConstant.extraLarge,
                    ),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.2),
                      borderRadius: ShapeConstant.extraLarge,
                      onTap: () async {
                        final copyOnTap =
                            ref.read(behaviorControllerProvider).copyOnTap;
                        if (selected.isNotEmpty) {
                          final bool inList = selected.contains(item);
                          inList
                              ? ref
                                  .read(selectedEntriesProvider.notifier)
                                  .removeSelected(item)
                              : ref
                                  .read(selectedEntriesProvider.notifier)
                                  .addSelected(item);
                        } else if (!tap && copyOnTap) {
                          hasTapped.value = true;
                          await AppUtils.copyToClipboard(item.getOTP());
                          Future<void>.delayed(const Duration(seconds: 2), () {
                            hasTapped.value = false;
                          });
                        }
                      },
                      onLongPress: onLongPress,
                      child: Slidable(
                        key: ValueKey(index),
                        startActionPane: ActionPane(
                          extentRatio: 0.2,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: onEdit,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              icon: Icons.edit_rounded,
                              borderRadius: ShapeConstant.extraLargeRight,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          extentRatio: 0.2,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: onDelete,
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                              foregroundColor:
                                  Theme.of(context).colorScheme.error,
                              icon: Icons.delete_rounded,
                              borderRadius: ShapeConstant.extraLargeLeft,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              child: builder(tap),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
