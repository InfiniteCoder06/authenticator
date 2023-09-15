// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpie_flutter/riverpie_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// 🌎 Project imports:
import 'package:authenticator/features/home/widgets/progress.controller.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.ref.watch(progressProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SfLinearGauge(
        maximum: 29,
        showLabels: false,
        showTicks: false,
        animateRange: true,
        axisTrackStyle: LinearAxisTrackStyle(
          thickness: 3.0,
          color: Theme.of(context).colorScheme.background,
        ),
        barPointers: [
          LinearBarPointer(
            thickness: 4.0,
            value: progress,
            animationType: LinearAnimationType.ease,
          )
        ],
      ),
    );
  }
}
