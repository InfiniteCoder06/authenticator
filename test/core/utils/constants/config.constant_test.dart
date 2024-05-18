// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/config.constant.dart';

void main() {
  test('titleConstraints', () {
    expect(ConfigConstant.titleConstraints, const BoxConstraints(minWidth: 80));
  });

  test('sliverExpandedHeight', () {
    expect(ConfigConstant.sliverExpandedHeight, 200);
  });

  test('margin constants', () {
    expect(ConfigConstant.margin0, 4.0);
    expect(ConfigConstant.margin1, 8.0);
    expect(ConfigConstant.margin2, 16.0);
  });

  test('iconSize constants', () {
    expect(ConfigConstant.iconSize1, 16.0);
    expect(ConfigConstant.iconSize2, 24.0);
    expect(ConfigConstant.iconSize3, 32.0);
    expect(ConfigConstant.iconSize4, 48.0);
    expect(ConfigConstant.iconSize5, 64.0);
  });

  test('objectHeight constants', () {
    expect(ConfigConstant.objectHeight1, 48.0);
    expect(ConfigConstant.objectHeight2, 56.0);
    expect(ConfigConstant.objectHeight3, 64.0);
    expect(ConfigConstant.objectHeight4, 72.0);
    expect(ConfigConstant.objectHeight5, 96.0);
    expect(ConfigConstant.objectHeight6, 120.0);
    expect(ConfigConstant.objectHeight7, 240.0);
  });

  test('duration constants', () {
    expect(ConfigConstant.fadeDuration, const Duration(milliseconds: 200));
    expect(ConfigConstant.duration, const Duration(milliseconds: 300));
  });

  test('layoutPadding', () {
    expect(ConfigConstant.layoutPadding,
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0));
  });

  test('sizedBox constants', () {
    expect(
        ConfigConstant.sizedBoxH0.height, const SizedBox(height: 4.0).height);
    expect(
        ConfigConstant.sizedBoxH1.height, const SizedBox(height: 8.0).height);
    expect(
        ConfigConstant.sizedBoxH2.height, const SizedBox(height: 16.0).height);
    expect(ConfigConstant.sizedBoxW0.width, const SizedBox(width: 4.0).width);
    expect(ConfigConstant.sizedBoxW1.width, const SizedBox(width: 8.0).width);
    expect(ConfigConstant.sizedBoxW2.width, const SizedBox(width: 16.0).width);
  });

  test('scrollToTopCurve', () {
    expect(ConfigConstant.scrollToTopCurve, Curves.fastLinearToSlowEaseIn);
  });
}
