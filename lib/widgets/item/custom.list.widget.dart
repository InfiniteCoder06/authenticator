// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/shape.util.dart';

class CustomList extends StatelessWidget {
  const CustomList(
    this.index, {
    required this.child,
    super.key,
    this.onPress,
    this.onLongPress,
  });
  final int index;
  final Widget child;
  final void Function()? onPress;
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
    );
  }
}
