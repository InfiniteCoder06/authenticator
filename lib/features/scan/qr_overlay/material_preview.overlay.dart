// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/features/scan/qr_overlay/material_barcode_frame.painter.dart';
import 'package:authenticator/features/scan/qr_overlay/material_sensing.painter.dart';

class MaterialPreviewOverlay extends StatefulWidget {
  const MaterialPreviewOverlay(
      {super.key, this.animateDetection = true, this.aspectRatio = 1 / 1});

  final bool animateDetection;
  final double aspectRatio;

  @override
  MaterialPreviewOverlayState createState() => MaterialPreviewOverlayState();
}

class MaterialPreviewOverlayState extends State<MaterialPreviewOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacitySequence;
  late Animation<double> _inflateSequence;

  @override
  void initState() {
    super.initState();

    if (widget.animateDetection) {
      _controller = AnimationController(
          duration: const Duration(milliseconds: 1100), vsync: this);

      const fadeIn = 20.0;
      const wait = 2.0;
      const expand = 25.0;

      _opacitySequence = TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: fadeIn),
        TweenSequenceItem(tween: ConstantTween(1.0), weight: wait),
        TweenSequenceItem(
            tween: Tween(begin: 1.0, end: 0.0)
                .chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: expand),
      ]).animate(_controller);

      _inflateSequence = TweenSequence([
        TweenSequenceItem(tween: ConstantTween(0.0), weight: fadeIn + wait),
        TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: expand),
      ]).animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: SizedBox.expand(
          child: widget.animateDetection
              ? _buildAnimation(context)
              : CustomPaint(
                  painter: MaterialBarcodeFramePainter(
                    widget.aspectRatio,
                    context,
                  ),
                ),
        ),
      );

  Widget _buildAnimation(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: MaterialBarcodeFramePainter(widget.aspectRatio, context),
          foregroundPainter: MaterialBarcodeSensingPainter(
            inflate: _inflateSequence.value,
            opacity: _opacitySequence.value,
          ),
        ),
      );
}
