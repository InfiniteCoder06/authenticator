// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progress.controller.g.dart';

@Riverpod(keepAlive: true)
class Progress extends _$Progress {
  @override
  double build() {
    postInit();
    var seconds = 0.0;
    if (DateTime.now().second > 29) {
      seconds = DateTime.now().second - 30.0;
    } else {
      seconds = DateTime.now().second.toDouble();
    }
    return seconds;
  }

  void postInit() {
    Stream.periodic(Durations.medium2).listen((_) => ticked());
  }

  void ticked() {
    if (DateTime.now().second > 29) {
      state = DateTime.now().second - 30.0;
    } else {
      state = DateTime.now().second.toDouble();
    }
  }
}
