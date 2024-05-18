// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/validator.util.dart';

void main() {
  test('FormControl is valid if value equals to validator value', () {
    // Given: an invalid control
    final control = FormControl<String>(
      value: "",
      validators: [const Base32Validator()],
    );

    expect(control.valid, false);
    expect(control.hasError('validBase32'), true);
  });
}
