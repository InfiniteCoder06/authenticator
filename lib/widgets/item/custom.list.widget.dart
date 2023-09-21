// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/shape.util.dart';

class CustomList extends StatelessWidget {
  const CustomList(
    this.index, {
    required this.child,
    super.key,
    this.onPress,
    this.onDelete,
    this.onEdit,
    this.onLongPress,
  });
  final int index;
  final Widget child;
  final void Function()? onPress;
  final void Function(BuildContext context)? onDelete;
  final void Function(BuildContext context)? onEdit;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
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
                borderRadius: Shape.extraLarge,
              ),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.2),
                borderRadius: Shape.extraLarge,
                onTap: onPress,
                onLongPress: onLongPress,
                child: Slidable(
                  key: ValueKey(index),
                  startActionPane: ActionPane(
                    extentRatio: 0.2,
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: onEdit,
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.tertiary,
                        icon: Icons.edit_rounded,
                        borderRadius: Shape.extraLargeRight,
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
                        foregroundColor: Theme.of(context).colorScheme.error,
                        icon: Icons.delete_rounded,
                        borderRadius: Shape.extraLargeLeft,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
