// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  LoadingOverlay({super.key, required this.child})
      : _isLoadingNotifier = ValueNotifier(false);

  final ValueNotifier<bool> _isLoadingNotifier;
  final Widget child;

  static LoadingOverlay of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<LoadingOverlay>()!;

  void show() {
    _isLoadingNotifier.value = true;
  }

  void hide() {
    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _isLoadingNotifier,
        child: child,
        builder: (context, isLoading, child) => Stack(
          children: [
            child!,
            if (isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: const ModalBarrier(
                    dismissible: false, color: Colors.black54),
              ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
      );
}
