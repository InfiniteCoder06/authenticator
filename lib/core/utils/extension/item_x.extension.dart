// 🎯 Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// 📦 Package imports:
import 'package:archive/archive.dart';
import 'package:fpdart/fpdart.dart';
import 'package:otp/otp.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/otp.util.dart';

extension ItemX on Item {
  String getSecret() {
    return fields
        .firstWhere((field) => field.identifier == 'secret')
        .data
        .value!;
  }

  String getOTP() {
    final String otp = OTP.generateTOTPCodeString(
      getSecret(),
      DateTime.now().millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
    return otp;
  }

  Option<Uint8List> getIcon() {
    final icon = iconUrl;
    if (icon.isEmpty) {
      return none();
    }
    return some(Uint8List.fromList(
      GZipDecoder().decodeBytes(
        base64Decode(icon),
      ),
    ));
  }

  Option<String> getIssuer() {
    final issuer = fields.where((field) => field.identifier == 'issuer');
    if (issuer.isEmpty || issuer.first.data.value!.isEmpty) {
      return none();
    } else {
      return some(issuer.first.data.value!);
    }
  }

  Uri get uri => OtpUtils.getURI(this);
}
