// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:logger/logger.dart';

// 🌎 Project imports:
import 'package:authenticator/features/settings/logger/logger.screen.dart';

class ConsoleLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(debugPrint);
    LogConsolePage.add(event);
  }
}
