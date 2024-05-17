// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppTotpField extends HookWidget {
  const AppTotpField({
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
    final obscureText = useState(true);
    return ReactiveTextField(
      formControlName: formName,
      obscureText: obscureText.value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: obscureText.value ? "Show Secret" : "Hide Secret",
          icon: Icon(obscureText.value
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded),
          onPressed: () => obscureText.value = !obscureText.value,
        ),
      ),
    );
  }
}
