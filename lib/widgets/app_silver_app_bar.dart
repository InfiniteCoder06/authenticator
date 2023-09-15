// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_fade_in.dart';
import 'package:authenticator/widgets/app_pop_button.dart';

class AppExpandedAppBar extends StatelessWidget {
  const AppExpandedAppBar({
    super.key,
    this.actions,
    this.subtitleIcon,
    this.fallbackRouter,
  });

  final IconData? subtitleIcon;
  final List<Widget>? actions;
  final AppRouter? fallbackRouter;

  @override
  Widget build(BuildContext context) {
    final AppRouter? fallbackRouter =
        this.fallbackRouter ?? AppBarTitle.router(context);
    return MorphingSliverAppBar(
      expandedHeight: 152.0,
      collapsedHeight: 64.0,
      leading: ModalRoute.of(context)?.settings.name == "/"
          ? null
          : const AppPopButton(),
      pinned: true,
      floating: true,
      stretch: true,
      title: const Text(""),
      elevation: Theme.of(context).appBarTheme.elevation,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: AppFadeIn(
          duration: ConfigConstant.duration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(top: 72.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fallbackRouter?.title ?? "",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
