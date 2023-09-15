// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:authenticator/core/fields/textfield.field.dart';
import 'package:authenticator/core/fields/totp.field.dart';
import 'package:authenticator/core/models/field.model.dart';

class FieldParser {
  static Widget parse(Field field) {
    // TEXT FIELD
    if (field.type == FieldType.textField.name) {
      return AppTextField(field);
    }
    // TEXT AREA
    else if (field.type == FieldType.totp.name) {
      return AppTotpField(field);
    } else {
      throw 'Unknown field type';
    }
  }
}
