// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class MaterialBarcodeFramePainter extends CustomPainter {
  const MaterialBarcodeFramePainter(this.aspectRatio, this.context);

  final double aspectRatio;
  final BuildContext context;

  static final backgroundPaint = Paint()..color = Colors.black38;

  @override
  void paint(Canvas canvas, Size size) {
    final screenRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final cutOutWidth = screenRect.width - 45;
    final cutOutHeight = 1 / aspectRatio * cutOutWidth;
    final cutOut = RRect.fromRectXY(
      Rect.fromCenter(
        center: screenRect.center,
        width: cutOutWidth,
        height: cutOutHeight,
      ),
      12,
      12,
    );

    final cutOutPath = Path.combine(PathOperation.difference,
        Path()..addRect(screenRect), Path()..addRRect(cutOut));

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Theme.of(context).colorScheme.primary;

    canvas
      ..drawPath(cutOutPath, backgroundPaint)
      ..drawRRect(cutOut.deflate(borderPaint.strokeWidth / 2), borderPaint);
  }

  @override
  bool shouldRepaint(MaterialBarcodeFramePainter oldDelegate) => false;
}
