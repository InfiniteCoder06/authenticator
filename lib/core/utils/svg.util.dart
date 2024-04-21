// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class SvgUtils {
  static Future<String> renderIllustration(
      BuildContext context, Color color, String path) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final svgString = await assetBundle.loadString(path);

    String valueString = color.toString().split('(0x')[1].split(')')[0];
    valueString = valueString.substring(2, valueString.length);
    return svgString.replaceAll("#6c63ff", "#$valueString");
  }
}
