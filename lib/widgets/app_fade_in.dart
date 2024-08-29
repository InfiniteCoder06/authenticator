// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';

class AppFadeIn extends StatelessWidget {
  const AppFadeIn({
    super.key,
    required this.child,
    this.duration = ConfigConstant.fadeDuration,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      duration: duration,
      tween: IntTween(begin: 0, end: 1),
      child: child,
      builder: (context, value, child) => AnimatedOpacity(
        opacity: value == 1 ? 1.0 : 0.0,
        duration: ConfigConstant.fadeDuration,
        child: child,
      ),
    );
  }
}
