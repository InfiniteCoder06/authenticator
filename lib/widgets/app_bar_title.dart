// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    this.fallbackRouter,
    this.overridedTitle,
    this.icon,
  });

  final AppRouter? fallbackRouter;
  final String? overridedTitle;
  final IconData? icon;

  static AppRouter? fromName(String? name) {
    AppRouter? router;
    for (AppRouter e in AppRouter.values) {
      if (e.path == name) {
        router = e;
        break;
      }
    }
    return router;
  }

  static AppRouter? router(
    BuildContext context, [
    AppRouter? fallbackRouter,
  ]) {
    String? name = ModalRoute.of(context)?.settings.name;
    return fromName(name) ?? fallbackRouter;
  }

  @override
  Widget build(BuildContext context) {
    String? title =
        overridedTitle ?? fallbackRouter?.title ?? router(context)?.title;

    if (icon != null) {
      return RichText(
        text: TextSpan(
          text: title ?? "",
          style: Theme.of(context).appBarTheme.titleTextStyle,
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  icon,
                  size: ConfigConstant.iconSize1,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Text(
        title ?? "",
        style: Theme.of(context).appBarTheme.titleTextStyle,
      );
    }
  }
}
