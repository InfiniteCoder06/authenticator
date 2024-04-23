// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class SvgUtils {
  static Future<String> renderIllustration(
      AssetBundle assetBundle, Color color, String path) async {
    final svgString = await assetBundle.loadString(path);

    return svgString.replaceAll(
        "#6c63ff", '#${color.value.toRadixString(16).substring(2)}');
  }
}
