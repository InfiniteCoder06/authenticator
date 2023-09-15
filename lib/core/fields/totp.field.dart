// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/field.model.dart';

class AppTotpField extends HookWidget {
  const AppTotpField(
    this.field, {
    super.key,
  });

  final Field field;

  @override
  Widget build(BuildContext context) {
    final obscureTextController = useValueNotifier(true);
    return ValueListenableBuilder(
      valueListenable: obscureTextController,
      builder: (context, obscureText, child) {
        return ReactiveTextField(
          readOnly: field.readOnly,
          formControlName: field.identifier,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureText,
          decoration: InputDecoration(
            isDense: true,
            labelText: field.data.label,
            hintText: field.data.hint,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(obscureText
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded),
              onPressed: () => obscureTextController.value = !obscureText,
            ),
          ),
        );
      },
    );
  }
}
