// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/features/home/home.controller.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';

class HomeInfoBar extends HookConsumerWidget {
  const HomeInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show = ref.watch(showBackupBannerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return AppCrossFade(
      firstChild: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
        child: Material(
          color: colorScheme.errorContainer,
          borderRadius: ShapeConstant.extraLarge,
          child: InkWell(
            borderRadius: ShapeConstant.extraLarge,
            onTap: () async {
              await Navigator.of(context).pushNamed(AppRouter.account.path);
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
  }
}
