import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:authenticator/core/utils/mixin/schedule.mixin.dart';

class TestClass with ScheduleMixin {}

void main() {
  late TestClass testClass;

  setUp(() {
    testClass = TestClass();
  });

  test('schedules and executes an action', () async {
    bool actionExecuted = false;

    testClass.scheduleAction(() {
      actionExecuted = true;
    }, duration: const Duration(milliseconds: 100));

    await Future.delayed(const Duration(milliseconds: 200));

    expect(actionExecuted, true);
  });

  test('cancels a scheduled action', () async {
    bool actionExecuted = false;
    Key testKey = const Key('test');

    testClass.scheduleAction(() {
      actionExecuted = true;
    }, duration: const Duration(milliseconds: 100), key: testKey);

    testClass.cancelTimer(testKey);

    await Future.delayed(const Duration(milliseconds: 200));

    expect(actionExecuted, false);
  });

  test('replaces a single timer with a new one', () async {
    bool firstActionExecuted = false;
    bool secondActionExecuted = false;

    testClass.scheduleAction(() {
      firstActionExecuted = true;
    }, duration: const Duration(milliseconds: 100));

    testClass.scheduleAction(() {
      secondActionExecuted = true;
    }, duration: const Duration(milliseconds: 200));

    await Future.delayed(const Duration(milliseconds: 300));

    expect(firstActionExecuted, false);
    expect(secondActionExecuted, true);
  });

  test('replaces a keyed timer with a new one', () async {
    bool firstActionExecuted = false;
    bool secondActionExecuted = false;
    Key testKey = const Key('test');

    testClass.scheduleAction(() {
      firstActionExecuted = true;
    }, duration: const Duration(milliseconds: 100), key: testKey);

    testClass.scheduleAction(() {
      secondActionExecuted = true;
    }, duration: const Duration(milliseconds: 200), key: testKey);

    await Future.delayed(const Duration(milliseconds: 300));

    expect(firstActionExecuted, false);
    expect(secondActionExecuted, true);
  });
}
