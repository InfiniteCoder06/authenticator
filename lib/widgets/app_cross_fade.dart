// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';

class AppCrossFade extends StatelessWidget {
  const AppCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    this.alignment = Alignment.topCenter,
    this.duration = ConfigConstant.duration,
  });

  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final AlignmentGeometry alignment;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: alignment,
      firstChild: firstChild,
      secondChild: secondChild,
      sizeCurve: Curves.ease,
      crossFadeState:
          showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
    );
  }
}
