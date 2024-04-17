// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:reactive_forms/reactive_forms.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.formName,
    required this.label,
    required this.hint,
  });

  final String formName;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControlName: formName,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
