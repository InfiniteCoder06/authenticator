// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/fields/totp.field.dart';
import 'package:authenticator/core/utils/globals.dart';

void main() {
  testWidgets('Totp Field Test',
      (tester) async {
    final form = fb.group({
      'secret': fb.control<String>('',
          [Validators.required, Validators.pattern(RegExp(kSecretPattern))]),
    });

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: const AppTotpField(
            formName: 'secret',
            label: 'Secret',
            hint: '',
          ),
        ),
      ),
    ));

    expect(find.text('InvalidSecret'), findsNothing);

    form.control('secret').value = 'InvalidSecret';
    await tester.pump();

    expect(find.text('InvalidSecret'), findsOneWidget);
  });

  testWidgets('Validation Required', (tester) async {
    final form = fb.group({
      'secret': fb.control<String>('',
          [Validators.required, Validators.pattern(RegExp(kSecretPattern))]),
    });

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: const AppTotpField(
            formName: 'secret',
            label: 'Secret',
            hint: '',
          ),
        ),
      ),
    ));

    var textField = tester.firstWidget<TextField>(find.byType(TextField));

    textField.focusNode?.requestFocus();
    await tester.pump();
    expect(textField.focusNode?.hasFocus, true);

    // Expect: errors are not visible yet
    expect(textField.decoration?.errorText, null, reason: 'errors are visible');

    // When: call FormControl.unfocus()
    (form.control('secret') as FormControl).unfocus();
    await tester.pump();

    // Then: the errors are visible
    textField = tester.firstWidget(find.byType(TextField)) as TextField;
    expect(textField.decoration?.errorText, ValidationMessage.required);
  });

  testWidgets('Validation Pattern', (tester) async {
    final form = fb.group({
      'secret': fb.control<String>('',
          [Validators.required, Validators.pattern(RegExp(kSecretPattern))]),
    });

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: const AppTotpField(
            formName: 'secret',
            label: 'Secret',
            hint: '',
          ),
        ),
      ),
    ));

    var textField = tester.firstWidget<TextField>(find.byType(TextField));

    textField.focusNode?.requestFocus();
    await tester.pump();

    form.control('secret').value = 'InvalidSecret';
    await tester.pump();

    (form.control('secret') as FormControl).unfocus();
    await tester.pump();

    expect(find.text(ValidationMessage.pattern), findsOneWidget);

    textField.focusNode?.requestFocus();
    await tester.pump();

    form.control('secret').value = 'JBSWY3DPEHPK3PXP';
    await tester.pump();

    (form.control('secret') as FormControl).unfocus();
    await tester.pump();

    expect(textField.decoration?.errorText, null);
  });
}
