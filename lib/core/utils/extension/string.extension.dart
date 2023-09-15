// 🌎 Project imports:
import 'package:authenticator/core/models/field.model.dart';

extension StringX on String {
  String type() {
    if (this == 'issuer') {
      return FieldType.textField.name;
    } else if (this == 'secret') {
      return FieldType.totp.name;
    } else {
      throw 'Unknown field type';
    }
  }
}
