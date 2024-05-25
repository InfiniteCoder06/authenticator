// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:otp/otp.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';

void main() {
  const uriString =
      "otpauth://totp/Github:test@gmail.com?period=30&secret=JBSWY3DPEHPK3PXP&digits=6&algorithm=sha1&issuer=Github";
  final item = Item.fromUri("test@gmail.com", "JBSWY3DPEHPK3PXP", "Github");
  test('Item Extension - Secret Test', () {
    var secret = item.getSecret();
    expect(secret, "JBSWY3DPEHPK3PXP");
  });

  test('Item Extension - Secret Test', () {
    var issuer = item.getIssuer().getOrElse(() => '');
    expect(issuer, "Github");
  });

  test('Item Extension - URI', () {
    var uri = item.uri;
    expect(uri, Uri.parse(uriString));
  });

  test('Generates a valid OTP', () {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final otp = item.getOTP();
    expect(otp, isNotEmpty);
    expect(otp.length, 6);
    expect(
      OTP.generateTOTPCodeString(
        item.getSecret(),
        currentTime,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      ),
      otp,
    );
  });

  test('Generates different OTPs for different times', () {
    final time1 = DateTime.now().millisecondsSinceEpoch;
    final time2 = time1 + 30000;

    final otp1 = item.getOTP();
    final otp2 = OTP.generateTOTPCodeString(
      item.getSecret(),
      time2,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );

    expect(otp1, isNotEmpty);
    expect(otp2, isNotEmpty);
    expect(otp1, isNot(equals(otp2)));
  });

  group('Get Icon', () {
    test('Returns none when iconUrl is empty', () {
      final result = item.getIcon();
      expect(result.isNone(), isTrue);
    });

    test('Returns some with Uint8List when iconUrl is not empty', () {
      const base64EncodedIcon =
          'H4sIAAAAAAAAA+3BMQEAAADCoPVPbQwfoAAAAAAAAAAAAAAAAIC3AYbSVKsAQAAA';
      final result = item.copyWith(iconUrl: base64EncodedIcon).getIcon();
      expect(result.isSome(), isTrue);
    });
  });
}
