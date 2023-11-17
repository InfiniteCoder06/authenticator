// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:authenticator/features/home/widgets/progress.controller.dart';

class ProgressBar extends ConsumerWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomProgressBar(
        value: progress / 29,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class CustomProgressBar extends ProgressIndicator {
  const CustomProgressBar({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    this.animationDuration = const Duration(milliseconds: 850),
    this.goingBackAnimationDuration = Durations.short4,
    this.animationCurve = Curves.easeIn,
  }) : assert(minHeight == null || minHeight > 0);

  /// {@template flutter.material.LinearProgressIndicator.trackColor}
  /// Color of the track being filled by the linear indicator.
  ///
  /// If [AnimatedLinearProgressIndicator.backgroundColor] is null then the
  /// ambient [AnimatedLinearProgressIndicator.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.background]
  /// will be used to draw the track.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;
  final double? minHeight;
  final Duration? animationDuration;
  final Duration? goingBackAnimationDuration;
  final Curve animationCurve;
  @override
  State<CustomProgressBar> createState() => CustomProgressBarState();
}

class CustomProgressBarState extends State<CustomProgressBar>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  AnimationController? _goingBackController;
  Tween<double>? _tween;
  Animation<double>? _animation;
  Animation<double>? _goingBackAnimation;
  bool _goingBack = false;
  void _setControllers() {
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _goingBackController = AnimationController(
      duration: widget.goingBackAnimationDuration,
      vsync: this,
    );
    _tween = Tween(begin: widget.value, end: widget.value);
    _animation = _tween?.animate(
      CurvedAnimation(
        curve: widget.animationCurve,
        parent: _controller!,
      ),
    );
    _goingBackAnimation = _tween?.animate(
      CurvedAnimation(
        curve: widget.animationCurve,
        parent: _goingBackController!,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setControllers();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _goingBack ? _goingBackAnimation! : _animation!,
        builder: (context, child) {
          return LinearProgressIndicator(
            key: widget.key,
            value: _goingBack ? _goingBackAnimation!.value : _animation!.value,
            backgroundColor: widget.backgroundColor,
            color: widget.color,
            valueColor: widget.valueColor,
            minHeight: widget.minHeight,
            semanticsLabel: widget.semanticsLabel,
            semanticsValue: widget.semanticsValue,
          );
        });
  }

  @override
  void didUpdateWidget(CustomProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.animationDuration != widget.animationDuration) ||
        (oldWidget.goingBackAnimationDuration !=
            widget.goingBackAnimationDuration) ||
        (oldWidget.animationCurve != widget.animationCurve)) {
      _setControllers();
    }
    double animationOldValue = 0;
    if (_goingBack) {
      animationOldValue = _goingBackAnimation!.value;
    } else {
      animationOldValue = _animation!.value;
    }
    if (_animation!.value > widget.value!) {
      _goingBack = true;
      _tween?.begin = animationOldValue;
      _controller?.reset();
      _goingBackController?.reset();
      _tween?.end = widget.value;
      _goingBackController?.forward();
    } else {
      _goingBack = false;
      _tween?.begin = animationOldValue;
      _controller?.reset();
      _goingBackController?.reset();
      _tween?.end = widget.value;
      _controller?.forward();
    }
  }

  @override
  dispose() {
    _controller?.dispose(); // you need this
    super.dispose();
  }
}
