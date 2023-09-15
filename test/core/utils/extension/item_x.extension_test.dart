// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

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
}
