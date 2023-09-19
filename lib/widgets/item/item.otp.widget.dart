// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:basic_utils/basic_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpie_flutter/riverpie_flutter.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/features/home/widgets/progress.controller.dart';
import 'package:authenticator/features/settings/behaviour/behaviour.controller.dart';

class ItemOTP extends HookConsumerWidget {
  const ItemOTP(
    this.item, {
    super.key,
    this.selected = false,
    this.copied = false,
  });
  final Item item;
  final bool selected;
  final bool copied;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(behaviorControllerProvider);
    context.ref.watch(progressProvider);
    return AnimatedCrossFade(
      firstChild: AnimatedOpacity(
        duration: const Duration(milliseconds: 1),
        opacity: copied ? 0 : 1,
        child: Text(
          StringUtils.addCharAtPosition(
            item.getOTP(),
            " ",
            state.codeGroup,
            repeat: true,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'Poppins',
                fontSize: state.fontSize.toDouble(),
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
      secondChild: AnimatedOpacity(
        duration: const Duration(milliseconds: 1),
        opacity: copied ? 1 : 0,
        child: Text(
          'Copied',
          style: TextStyle(
            fontSize: state.fontSize.toDouble(),
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      crossFadeState:
          copied ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 500),
    );
  }
}
