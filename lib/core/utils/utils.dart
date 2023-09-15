// 🐦 Flutter imports:
import 'package:flutter/services.dart';

class AppUtils {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
