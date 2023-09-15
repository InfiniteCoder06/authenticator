// 🐦 Flutter imports:
import 'package:flutter/services.dart';

class SvgUtils {
  static Future<String> renderIllustration(Color exColor, String path) async {
    final String image = await rootBundle.loadString(path);
    String valueString = exColor.toString().split('(0x')[1].split(')')[0];
    valueString = valueString.substring(2, valueString.length);
    return image.replaceAll("#6c63ff", "#$valueString");
  }
}
