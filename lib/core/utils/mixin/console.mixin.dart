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

  void info(String message) => _log(Level.info, message);
  void debug(String message) => _log(Level.debug, message);
  void warning(String message) => _log(Level.warning, message);
  void error(String message) => _log(Level.error, "🔴 $message");
  void fatal(String message) => _log(Level.fatal, message);
  void trace(String message) => _log(Level.trace, message);

  void _log(Level level, String message) {
    logger.log(level, '$name: $message');
  }
}
