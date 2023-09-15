// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/widgets/app_tap_effect.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final double size;
  final EdgeInsets padding;
  final String? tooltip;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.size = 24.0,
    this.padding = const EdgeInsets.all(8),
    this.tooltip,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      type: backgroundColor == null
          ? MaterialType.transparency
          : MaterialType.circle,
      color: backgroundColor,
      child: buildPlatformWrapper(
        child: icon,
        context: context,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip ?? '',
        child: button,
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      child: button,
    );
  }

  Widget buildPlatformWrapper({
    required Widget child,
    required BuildContext context,
  }) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          onLongPress: onLongPress,
          child: Padding(
            padding: padding,
            child: icon,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return AppTapEffect(
          onTap: onPressed,
          onLongPressed: onLongPress,
          child: Padding(
            padding: padding,
            child: icon,
          ),
        );
    }
  }
}
