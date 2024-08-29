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
  // TODO:
  String getSecret() {
    return secret;
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
    final issuer = this.issuer;
    return issuer.isEmpty ? none() : some(issuer);
  }

  Uri get uri => OtpUtils.getURI(this);
}
