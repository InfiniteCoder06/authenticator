// 📦 Package imports:
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/otp.util.dart';

class Base32Validator extends Validator<dynamic> {
  const Base32Validator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return control.value is String &&
            OtpUtils.isValidSecret(
                (control.value as String).replaceAll(" ", "").trim())
        ? null
        : {'Enter valid Base 32': false};
  }
}
