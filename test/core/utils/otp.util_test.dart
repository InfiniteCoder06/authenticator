// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/otp.util.dart';

void main() {
  const uriString =
      "otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example";
  test('Parse URI', () async {
    final parsedURI = Uri.parse(uriString);

    final List<String> strings = parsedURI.pathSegments.last.split(":");

    expect(parsedURI.scheme, 'otpauth');
    expect(parsedURI.host, 'totp');
    expect(strings.first, 'Example');
    expect(strings.last, 'alice@google.com');
    expect(parsedURI.queryParameters['secret'], 'JBSWY3DPEHPK3PXP');
  });

  test('Get Item', () async {
    final item = OtpUtils.parseURI(Uri.parse(uriString))
        .getOrElse((l) => Item.initial());

    expect(item.name, 'alice@google.com');
    expect(
        item.secret,
        'JBSWY3DPEHPK3PXP');
    expect(
        item.issuer,
        'Example');
  });
}
