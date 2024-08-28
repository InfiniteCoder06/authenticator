// 🐦 Flutter imports:
import 'package:flutter/material.dart';

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
        title: fallbackRouter?.title ?? "",
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
    this.title = '',
  });

  final String title;
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
            height: topSafeAreaPadding + height,
            child: AppBar(
              automaticallyImplyLeading: false,
              leading: ModalRoute.of(context)?.settings.name == "/"
                  ? null
                  : const AppPopButton(),
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
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      letterSpacing: -0.7,
                    ),
              ),
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
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
