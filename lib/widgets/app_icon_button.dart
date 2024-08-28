// 🐦 Flutter imports:
import 'package:flutter/material.dart';

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

    return Padding(
      padding: const EdgeInsets.all(4),
      child: button,
    );
  }

  Widget buildPlatformWrapper({
    required Widget child,
    required BuildContext context,
  }) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onPressed,
      onLongPress: onLongPress,
      child: Padding(
        padding: padding,
        child: icon,
      ),
    );
  }
}
