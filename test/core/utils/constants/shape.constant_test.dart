// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/constants/shape.constant.dart';

void main() {
  test('none is a BorderRadius with all radii 0', () {
    expect(ShapeConstant.none, const BorderRadius.all(Radius.circular(0)));
  });

  test('extraSmall is a BorderRadius with all radii 4', () {
    expect(
        ShapeConstant.extraSmall, const BorderRadius.all(Radius.circular(4)));
  });

  test('extraSmallTop has topLeft and topRight radii 4, others 0', () {
    expect(
      ShapeConstant.extraSmallTop,
      const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    );
  });

  test('small is a BorderRadius with all radii 8', () {
    expect(ShapeConstant.small, const BorderRadius.all(Radius.circular(8)));
  });

  test('medium is a BorderRadius with all radii 12', () {
    expect(ShapeConstant.medium, const BorderRadius.all(Radius.circular(12)));
  });

  test('large is a BorderRadius with all radii 16', () {
    expect(ShapeConstant.large, const BorderRadius.all(Radius.circular(16)));
  });

  test('largeEnd has topRight and bottomRight radii 16, others 0', () {
    expect(
      ShapeConstant.largeEnd,
      const BorderRadius.only(
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    );
  });

  test('largeTop has topLeft and topRight radii 16, others 0', () {
    expect(
      ShapeConstant.largeTop,
      const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    );
  });

  test('extraLarge is a BorderRadius with all radii 28', () {
    expect(
        ShapeConstant.extraLarge, const BorderRadius.all(Radius.circular(28)));
  });

  test('extraLargeTop has topLeft and topRight radii 28, others 0', () {
    expect(
      ShapeConstant.extraLargeTop,
      const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    );
  });

  test('extraLargeRight has topRight and bottomRight radii 28, others 0', () {
    expect(
      ShapeConstant.extraLargeRight,
      const BorderRadius.only(
        topRight: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
    );
  });

  test('extraLargeLeft has topLeft and bottomLeft radii 28, others 0', () {
    expect(
      ShapeConstant.extraLargeLeft,
      const BorderRadius.only(
        topLeft: Radius.circular(28),
        bottomLeft: Radius.circular(28),
      ),
    );
  });

  test('full is a BorderRadius with all radii 50', () {
    expect(ShapeConstant.full, const BorderRadius.all(Radius.circular(50)));
  });
}
