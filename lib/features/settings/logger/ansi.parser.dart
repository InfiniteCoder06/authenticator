// ignore_for_file: constant_identifier_names

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AnsiParser {
  AnsiParser(this.dark);

  static const TEXT = 0, BRACKET = 1, CODE = 2;

  final bool dark;

  late List<TextSpan> spans;
  Color? foreground;
  Color? background;

  void parse(String s) {
    spans = [];
    var state = TEXT;
    late StringBuffer buffer;
    var text = StringBuffer();
    var code = 0;
    late List<int> codes;

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];

      switch (state) {
        case TEXT:
          if (c == '\u001b') {
            state = BRACKET;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }

        case BRACKET:
          buffer.write(c);
          if (c == '[') {
            state = CODE;
          } else {
            state = TEXT;
            text.write(buffer);
          }

        case CODE:
          buffer.write(c);
          var codeUnit = c.codeUnitAt(0);
          if (codeUnit >= 48 && codeUnit <= 57) {
            code = code * 10 + codeUnit - 48;
            continue;
          } else if (c == ';') {
            codes.add(code);
            code = 0;
            continue;
          } else {
            if (text.isNotEmpty) {
              spans.add(createSpan(text.toString()));
              text.clear();
            }
            state = TEXT;
            if (c == 'm') {
              codes.add(code);
              handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }

      }
    }

    spans.add(createSpan(text.toString()));
  }

  void handleCodes(List<int> codes) {
    if (codes.isEmpty) {
      codes.add(0);
    }

    switch (codes[0]) {
      case 0:
        foreground = getColor(0, true);
        background = getColor(0, false);
      case 38:
        foreground = getColor(codes[2], true);
      case 39:
        foreground = getColor(0, true);
      case 48:
        background = getColor(codes[2], false);
      case 49:
        background = getColor(0, false);
    }
  }

  Color? getColor(int colorCode, bool foreground) {
    switch (colorCode) {
      case 0:
        return foreground ? Colors.black : Colors.transparent;
      case 12:
        return dark ? Colors.lightBlue[300]! : Colors.indigo[700]!;
      case 208:
        return dark ? Colors.orange[300]! : Colors.orange[700]!;
      case 196:
        return dark ? Colors.red[300]! : Colors.red[700]!;
      case 199:
        return dark ? Colors.pink[300]! : Colors.pink[700]!;
      default:
        return null;
    }
  }

  TextSpan createSpan(String text) => TextSpan(
        text: text,
        style: TextStyle(
          color: foreground,
          backgroundColor: background,
        ),
      );
}
