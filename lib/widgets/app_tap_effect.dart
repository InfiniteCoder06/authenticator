// 🐦 Flutter imports:
import 'package:flutter/material.dart';

enum AppTapEffectType {
  touchableOpacity,
  scaleDown,
  border,
}

class AppTapEffectBorderOption {
  final BoxShape shape;
  final double scale;
  final double width;
  final Color color;

  AppTapEffectBorderOption({
    required this.shape,
    required this.scale,
    required this.width,
    required this.color,
  });
}

class AppTapEffect extends StatefulWidget {
  const AppTapEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = Durations.short2,
    this.vibrate = false,
    this.behavior = HitTestBehavior.opaque,
    this.effects = const [
      AppTapEffectType.touchableOpacity,
    ],
    this.onLongPressed,
    this.borderOption,
  });

  final Widget child;
  final AppTapEffectBorderOption? borderOption;
  final List<AppTapEffectType> effects;
  final void Function()? onTap;
  final void Function()? onLongPressed;
  final Duration duration;
  final bool vibrate;
  final HitTestBehavior? behavior;

  @override
  State<AppTapEffect> createState() => _AppTapEffectState();
}

class _AppTapEffectState extends State<AppTapEffect>
    with SingleTickerProviderStateMixin {
  final double scaleActive = 0.98;
  final double opacityActive = 0.2;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  late Animation<double> borderAnimation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    scaleAnimation =
        Tween<double>(begin: 1, end: scaleActive).animate(controller);
    opacityAnimation =
        Tween<double>(begin: 1, end: opacityActive).animate(controller);
    borderAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTap() {
    if (widget.onTap != null) widget.onTap!();
    Feedback.forTap(context);
  }

  void onTapCancel() => controller.reverse();
  void onTapDown() => controller.forward();
  void onTapUp() {
    onTap();
    controller.reverse();
  }

  void onDoubleTap() async {
    controller.forward().then((value) => controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap != null) {
      return GestureDetector(
        behavior: widget.behavior,
        onLongPress: widget.onLongPressed,
        onTapDown: (detail) => onTapDown(),
        onTapUp: (detail) => onTapUp(),
        onTapCancel: () => onTapCancel(),
        child: buildChild(controller),
      );
    } else {
      return buildChild(controller);
    }
  }

  AnimatedBuilder buildChild(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        Widget result = child ?? const SizedBox();
        for (var effect in widget.effects) {
          switch (effect) {
            case AppTapEffectType.scaleDown:
              result = ScaleTransition(scale: scaleAnimation, child: result);
              break;
            case AppTapEffectType.touchableOpacity:
              result = Opacity(opacity: opacityAnimation.value, child: result);
              break;
            case AppTapEffectType.border:
              result = Stack(
                alignment: Alignment.center,
                children: [
                  result,
                  Positioned.fill(
                    child: Container(
                      transform: Matrix4.identity()
                        ..scale(widget.borderOption?.scale ?? 1.25),
                      transformAlignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: widget.borderOption?.width ?? 2,
                          color: Color.lerp(
                            Colors.transparent,
                            widget.borderOption?.color ??
                                Theme.of(context).colorScheme.onSurface,
                            borderAnimation.value,
                          )!,
                        ),
                        shape: widget.borderOption?.shape ?? BoxShape.circle,
                      ),
                    ),
                  )
                ],
              );
              break;
          }
        }
        return result;
      },
      child: widget.child,
    );
  }
}
