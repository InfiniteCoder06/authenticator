// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progress.controller.g.dart';

@Riverpod(keepAlive: true)
class Progress extends _$Progress {
  @override
  double build() {
    postInit();
    return 0.0;
  }

  void postInit() {
    Stream.periodic(const Duration(milliseconds: 300)).listen((_) => ticked());
  }

  void ticked() {
    if (DateTime.now().second > 30) {
      state = DateTime.now().second - 30.0;
    } else {
      state = DateTime.now().second.toDouble();
    }
  }
}
