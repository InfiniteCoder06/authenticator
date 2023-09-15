// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class Shape {
  static BorderRadius none = const BorderRadius.all(Radius.circular(0));
  static BorderRadius extraSmall = const BorderRadius.all(Radius.circular(4));
  static BorderRadius extraSmallTop = const BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(4),
  );
  static BorderRadius small = const BorderRadius.all(Radius.circular(8));
  static BorderRadius medium = const BorderRadius.all(Radius.circular(12));
  static BorderRadius large = const BorderRadius.all(Radius.circular(16));
  static BorderRadius largeEnd = const BorderRadius.only(
    topRight: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );
  static BorderRadius largeTop = const BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );
  static BorderRadius extraLarge = const BorderRadius.all(Radius.circular(28));
  static BorderRadius extraLargeTop = const BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(28),
  );
  static BorderRadius full = const BorderRadius.all(Radius.circular(50));
}
