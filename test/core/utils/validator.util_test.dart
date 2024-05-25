// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/validator.util.dart';

void main() {
  test('Empty Secret', () {
    // Given: an invalid control
    final control = FormControl<String>(
      value: "",
      validators: [const Base32Validator()],
    );

    expect(control.valid, false);
    expect(control.hasError('Enter valid Base 32'), true);
  });

  test('Random Secret', () {
    // Given: an invalid control
    final control = FormControl<String>(
      value: "reighdkfhgifdhgkl",
      validators: [const Base32Validator()],
    );

    expect(control.valid, false);
    expect(control.hasError('Enter valid Base 32'), true);
  });

  test('Test Secret with Spaces', () {
    // Given: an invalid control
    final control = FormControl<String>(
      value: "JBSW Y3DP EHPK 3PXP",
      validators: [const Base32Validator()],
    );

    expect(control.valid, true);
    expect(control.hasError('Enter valid Base 32'), false);
  });
}
