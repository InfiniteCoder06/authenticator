// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/fields/textfield.field.dart';

void main() {
  testWidgets('Textfield Test', (tester) async {
    final form = fb.group({
      'name': fb.control<String>('', [Validators.required]),
    });

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: const AppTextField(
            formName: 'name',
            label: 'Name',
            hint: 'test@example.com',
          ),
        ),
      ),
    ));

    expect(find.text('John'), findsNothing);

    form.control('name').value = 'John';
    await tester.pump();

    expect(find.text('John'), findsOneWidget);
  });
}
