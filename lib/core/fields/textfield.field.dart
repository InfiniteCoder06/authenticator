// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/field.model.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
    this.field, {
    super.key,
  });

  final Field field;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      readOnly: field.readOnly,
      formControlName: field.identifier,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        isDense: true,
        labelText: field.data.label,
        hintText: field.data.hint,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text("To Be Implemented"))),
        ),
      ),
    );
  }
}
