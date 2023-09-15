// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:riverpie/riverpie.dart';

final progressProvider =
    NotifierProvider<ProgressProvider, double>((ref) => ProgressProvider());

class ProgressProvider extends PureNotifier<double> {
  ProgressProvider();

  @override
  double init() => 0.0;

  late StreamSubscription? _tickerSubscription;

  @override
  void postInit() {
    _tickerSubscription = Stream.periodic(const Duration(milliseconds: 300))
        .listen((_) => ticked());
  }

  void ticked() {
    if (DateTime.now().second > 29) {
      state = DateTime.now().second - 30.0;
    } else {
      state = DateTime.now().second.toDouble();
    }
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}
