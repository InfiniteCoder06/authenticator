// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
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

    return SliverPersistentHeader(
      pinned: true,
      delegate: LargeCustomHeader(
        title: TweenAnimationBuilder(
          tween: IntTween(begin: 50, end: 0),
          duration: Durations.medium1,
          builder: (context, value, child) {
            return AnimatedPadding(
              padding: EdgeInsets.only(left: value.toDouble()),
              duration: Durations.short2,
              child: child,
            );
          },
          child: Hero(
            tag: 'MorphingAppBarTitle',
            child: Text(
              fallbackRouter?.title ?? "",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(letterSpacing: -0.7),
            ),
          ),
        ),
        topSafeAreaPadding: MediaQuery.of(context).padding.top,
        leading: ModalRoute.of(context)?.settings.name == "/"
            ? const SizedBox.shrink()
            : const AppPopButton(),
        height: 160,
      ),
    );
  }
}

class LargeCustomHeader extends SliverPersistentHeaderDelegate {
  LargeCustomHeader({
    required this.leading,
    required this.topSafeAreaPadding,
    required this.height,
    this.title = const SizedBox.shrink(),
  });

  final Widget title;
  final double height;

  final Widget leading;
  final double topSafeAreaPadding;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final titleAlignTween =
        AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft);
    final titleMarginTween = EdgeInsetsTween(
      begin: const EdgeInsets.only(left: 16, bottom: 0),
      end: const EdgeInsets.only(top: 0, left: 72),
    );

    final progress = ((shrinkOffset / maxExtent) * 100) / kToolbarHeight;
    final titleMarginProgress = titleMarginTween.lerp(progress.clamp(0, 1));
    final titleAlignProgress = titleAlignTween.lerp(progress.clamp(0, 1));
    return Container(
      color: Theme.of(context).colorScheme.surface,
      height: maxExtent,
      child: Stack(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: MorphingAppBar(
              leading: ModalRoute.of(context)?.settings.name == "/"
                  ? null
                  : const AppPopButton(),
              title: const Text(''),
            ),
          ),
          Container(
            height: height,
            padding: EdgeInsets.only(top: topSafeAreaPadding),
            alignment: titleAlignProgress,
            child: Container(
              alignment: Alignment.centerLeft,
              height: kToolbarHeight,
              margin: titleMarginProgress,
              child: title,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => kToolbarHeight + topSafeAreaPadding;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
