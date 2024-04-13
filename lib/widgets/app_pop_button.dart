// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:popover/popover.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_fade_in.dart';
import 'package:authenticator/widgets/app_icon_button.dart';
import 'package:authenticator/widgets/app_scale_in.dart';

class AppPopButton extends StatelessWidget {
  const AppPopButton({
    super.key,
    this.tooltip,
    this.onPressed,
    this.forceCloseButton = false,
  });
  final String? tooltip;
  final VoidCallback? onPressed;
  final bool forceCloseButton;

  static Widget? wrapper(BuildContext context) {
    return ModalRoute.of(context)?.canPop == true ? const AppPopButton() : null;
  }

  static IconData getIconData(BuildContext context) {
    final platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios;
    }
  }

  @override
  Widget build(BuildContext context) {
    ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog ||
            forceCloseButton;
    final routeHistory = NavigationHistoryObserver().history;

    List<Route<dynamic>> history = [...routeHistory].where((element) {
      bool notCurrentRoute =
          ModalRoute.of(context)?.hashCode != element.hashCode;
      bool hasRouteName = element.settings.name != null;
      return notCurrentRoute && hasRouteName;
    }).toList();

    // history.removeAt(0);

    return Center(
      child: AppIconButton(
        key: const Key("appBar.back"),
        icon: IconTheme.merge(
          data: const IconThemeData(size: ConfigConstant.iconSize2),
          child: useCloseButton
              ? const Icon(Icons.close_rounded)
              : const BackButtonIcon(),
        ),
        tooltip: useCloseButton
            ? tooltip ?? MaterialLocalizations.of(context).closeButtonLabel
            : MaterialLocalizations.of(context).backButtonTooltip,
        onLongPress:
            history.isNotEmpty ? () => onLongPress(history, context) : null,
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            Navigator.maybePop(context);
          }
        },
      ),
    );
  }

  void onLongPress(List<Route<dynamic>> history, BuildContext context) {
    void pop(Route<dynamic> til) {
      Navigator.of(context).popUntil((route) {
        return route.hashCode == til.hashCode;
      });
    }

    showPopover(
      context: context,
      backgroundColor: Colors.transparent,
      shadow: [],
      radius: 0,
      contentDyOffset: 2.0,
      transitionDuration: const Duration(milliseconds: 0),
      bodyBuilder: (context) => buildRouteHistory(context, history, pop),
      direction: PopoverDirection.bottom,
      width: 200,
      height: kToolbarHeight * history.length,
      arrowHeight: 4,
      arrowWidth: 8,
      onPop: () {},
    );
  }

  Widget buildRouteHistory(
    BuildContext context,
    List<Route<dynamic>> history,
    void Function(Route<dynamic> til) pop,
  ) {
    return AppScaleIn(
      curve: Curves.fastLinearToSlowEaseIn,
      transformAlignment: Alignment.center,
      duration: ConfigConstant.fadeDuration,
      child: AppFadeIn(
        child: Container(
          margin: const EdgeInsets.only(left: 12.0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: ShapeConstant.small,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Material(
            color: Theme.of(context).popupMenuTheme.color,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                history.length,
                (index) {
                  return buildRouteTile(
                    history,
                    index,
                    context,
                    pop,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRouteTile(
    List<Route<dynamic>> history,
    int index,
    BuildContext context,
    void Function(Route<dynamic> til) pop,
  ) {
    Route<dynamic> route = history[index];
    AppRouter? router = AppBarTitle.fromName(route.settings.name);

    return ListTile(
      leading: Icon(router?.icon ?? Icons.account_tree_rounded),
      title: Text(
        router?.title ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.maybePop(context);
        pop(route);
      },
    );
  }
}
