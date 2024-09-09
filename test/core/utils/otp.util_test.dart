// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/otp.util.dart';

void main() {
  group('Full URI', () {
    const uriString =
        "otpauth://totp/Example:alice@google.com?period=30&secret=JBSWY3DPEHPK3PXP&digits=6&algorithm=sha1&issuer=Example";
    const uriStringMulti =
        "otpauth://totp/Example:alice@google.com?period=30&secret=JBSWY3DPEHPK3PXP&digits=6&algorithm=sha1&issuer=Issuer";
    group("Parse URI", () {
      test('Parse URI Single', () {
        final parsedURI = Uri.parse(uriString);

        final List<String> strings = parsedURI.pathSegments.last.split(":");

        expect(parsedURI.scheme, 'otpauth');
        expect(parsedURI.host, 'totp');
        expect(strings.first, 'Example');
        expect(strings.last, 'alice@google.com');
        expect(parsedURI.queryParameters['issuer'], 'Example');
        expect(parsedURI.queryParameters['secret'], 'JBSWY3DPEHPK3PXP');
      });

      test('Parse URI Single', () {
        final parsedURI = Uri.parse(uriStringMulti);

        final List<String> strings = parsedURI.pathSegments.last.split(":");

        expect(parsedURI.scheme, 'otpauth');
        expect(parsedURI.host, 'totp');
        expect(strings.first, 'Example');
        expect(strings.last, 'alice@google.com');
        expect(parsedURI.queryParameters['issuer'], 'Issuer');
        expect(parsedURI.queryParameters['secret'], 'JBSWY3DPEHPK3PXP');
      });
    });

    group("Get Item", () {
      test('Get Item Single', () {
        final item = OtpUtils.parseURI(Uri.parse(uriString))
            .getOrElse((l) => (Item.initial(), []));

        expect(item.$1.name, 'alice@google.com');
        expect(item.$1.secret, 'JBSWY3DPEHPK3PXP');
        expect(item.$1.issuer, 'Example');
      });

      test('Get Item Multiple', () {
        final item = OtpUtils.parseURI(Uri.parse(uriStringMulti))
            .getOrElse((l) => (Item.initial(), []));

        expect(item.$2.length, 2);
        expect(item.$1.name, 'alice@google.com');
        expect(item.$1.secret, 'JBSWY3DPEHPK3PXP');
        expect(item.$2, ['Issuer', 'Example']);
      });
    });

    test('Get URI', () {
      final item = Item.initial().copyWith(
        name: 'alice@google.com',
        secret: 'JBSWY3DPEHPK3PXP',
        issuer: 'Example',
      );

      expect(OtpUtils.getURI(item), Uri.parse(uriString));
    });
  });

  group('Partial URI', () {
    const uriString =
        "otpauth://totp/alice@google.com?period=30&secret=JBSWY3DPEHPK3PXP&digits=6&algorithm=sha1&issuer=Example";
    test('Parse URI', () {
      final parsedURI = Uri.parse(uriString);

      final List<String> strings = parsedURI.pathSegments.last.split(":");

      expect(parsedURI.scheme, 'otpauth');
      expect(parsedURI.host, 'totp');
      expect(strings.last, 'alice@google.com');
      expect(parsedURI.queryParameters['issuer'], 'Example');
      expect(parsedURI.queryParameters['secret'], 'JBSWY3DPEHPK3PXP');
    });

    test('Get Item', () {
      final item = OtpUtils.parseURI(Uri.parse(uriString))
          .getOrElse((l) => (Item.initial(), []));

      expect(item.$1.name, 'alice@google.com');
      expect(item.$1.secret, 'JBSWY3DPEHPK3PXP');
      expect(item.$1.issuer, 'Example');
    });

    test('Get URI', () {
      const uriString =
          "otpauth://totp/alice@google.com?period=30&secret=JBSWY3DPEHPK3PXP&digits=6&algorithm=sha1";
      final item = Item.initial().copyWith(
        name: 'alice@google.com',
        secret: 'JBSWY3DPEHPK3PXP',
      );

      expect(OtpUtils.getURI(item), Uri.parse(uriString));
    });
  });

  group('Test Errors', () {
    test('Scheme Error', () {
      const scheme =
          "otpau://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example";
      final result = OtpUtils.parseURI(Uri.parse(scheme));

      expect(result.isLeft(), true);
      result.match((error) {
        expect(error, "Uri Scheme is Invalid otpau");
      }, (_) {});
    });

    test('Secret Error', () {
      const secretEmpty =
          "otpauth://totp/Example:alice@google.com?issuer=Example";
      const secretInvalid =
          "otpauth://totp/Example:alice@google.com?secret=12345678&issuer=Example";

      OtpUtils.parseURI(Uri.parse(secretEmpty)).match((error) {
        expect(error, "Parameter Secret is Required");
      }, (_) {});

      OtpUtils.parseURI(Uri.parse(secretInvalid)).match((error) {
        expect(error, "Parameter Secret is Invalid");
      }, (_) {});
    });

    test('Path Segments Error', () {
      const segments =
          "otpauth://totp/Example:alice@google.com:none?secret=JBSWY3DPEHPK3PXP&issuer=Example";
      final result = OtpUtils.parseURI(Uri.parse(segments));

      expect(result.isLeft(), true);
      result.match((error) {
        expect(error, "Invalid URI");
      }, (_) {});
    });
  });

  test('Is Valid Secret', () {
    List<String> validSecrets = [
      "HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ",
      "JBSWY3DPEHPK3PXP"
    ];
    List<String> invalidSecrets = [
      "",
      "very short",
      "extremely long secret with more than 32 characters",
      "12345678"
    ];

    for (var secret in validSecrets) {
      expect(OtpUtils.isValidSecret(secret), true,
          reason: "Valid secret should be accepted");
    }
    for (var secret in invalidSecrets) {
      expect(OtpUtils.isValidSecret(secret), false,
          reason: "Invalid secret should be rejected");
    }
  });
}
