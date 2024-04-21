// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:logger/logger.dart';

// 🌎 Project imports:
import 'package:authenticator/features/settings/logger/console_log.output.dart';

mixin ConsoleMixin {
  Console get console => Console(name: runtimeType.toString());
}

class TestingFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    final bool isTest = Platform.environment.containsKey('FLUTTER_TEST');
    return event.level.value >= level!.value && !isTest;
  }
}

class Console {
  final String name;
  Console({required this.name});

  final logger = Logger(
    filter: kIsWeb ? ProductionFilter() : TestingFilter(),
    output: ConsoleLogOutput(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 1,
      noBoxingByDefault: true,
    ),
  );

  void info(String message, {String? name}) =>
      _log(Level.info, message, customName: name);
  void debug(String message, {String? name}) =>
      _log(Level.debug, message, customName: name);
  void warning(String message, {String? name}) =>
      _log(Level.warning, message, customName: name);
  void error(String message, {String? name}) =>
      _log(Level.error, "🔴 $message", customName: name);
  void fatal(String message, {String? name}) =>
      _log(Level.fatal, message, customName: name);
  void trace(String message, {String? name}) =>
      _log(Level.trace, message, customName: name);

  void _log(Level level, String message, {String? customName}) {
    logger.log(level, '${customName ?? name}: $message');
  }
}
