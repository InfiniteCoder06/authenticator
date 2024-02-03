// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';
import 'package:authenticator/widgets/app_tap_effect.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    required this.label,
    this.iconData,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.loading = false,
  });

  final VoidCallback? onTap;
  final String label;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final button = buildButton(context);
    return AppTapEffect(
      onTap: onTap,
      effects: const [AppTapEffectType.scaleDown],
      child: AppCrossFade(
        showFirst: loading,
        secondChild: button,
        firstChild: Stack(
          children: [
            // bypass method
            Opacity(opacity: 0, child: button),
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(strokeCap: StrokeCap.round),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton buildButton(BuildContext context) {
    final foreground =
        foregroundColor ?? Theme.of(context).colorScheme.onPrimary;
    final background = backgroundColor ?? Theme.of(context).colorScheme.primary;

    if (iconData != null) {
      return TextButton.icon(
        icon: Icon(iconData, color: foreground),
        onPressed: null,
        style: buildButtonStyle(background),
        label: buildLabel(context, foreground),
      );
    } else {
      return TextButton(
        onPressed: null,
        style: buildButtonStyle(background),
        child: buildLabel(context, foreground),
      );
    }
  }

  ButtonStyle buildButtonStyle(Color background) {
    return TextButton.styleFrom(
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: Shape.full,
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
      ),
    );
  }

  Text buildLabel(BuildContext context, Color foreground) {
    return Text(
      "  $label  ",
      style:
          Theme.of(context).textTheme.labelLarge?.copyWith(color: foreground),
    );
  }
}
