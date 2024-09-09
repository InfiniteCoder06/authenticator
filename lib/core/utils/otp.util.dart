// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:uri/uri.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/core/utils/globals.dart';

class OtpUtils {
  static Either<String, (Item, List<String?>)> parseURI(Uri uri) {
    String name;
    String? issuer;
    String secret;

    if (uri.scheme != kScheme) {
      return left("Uri Scheme is Invalid ${uri.scheme}");
    }

    if (uri.queryParameters['secret'] == null) {
      secret = '';
      return left("Parameter Secret is Required");
    } else {
      secret = uri.queryParameters['secret'].toString();
      final isValid = isValidSecret(secret);
      if (!isValid) {
        return left("Parameter Secret is Invalid");
      }
    }

    final List<String> pathSegments = uri.pathSegments;
    var issuerSegments = "";
    var issuerParams = "";

    if (pathSegments.last.contains(":")) {
      final List<String> strings = uri.pathSegments.last.split(":");
      if (strings.length != 2) {
        return left("Invalid URI");
      }
      name = strings.elementAt(1);
      issuerSegments = strings.elementAt(0);
      issuerParams = uri.queryParameters['issuer'] ?? "";
    } else {
      issuerParams = uri.queryParameters['issuer'] ?? "";
      name = uri.pathSegments.last;
    }

    if (issuerParams.isNotEmpty &&
        issuerSegments.isNotEmpty &&
        issuerParams != issuerSegments) {
      return right(
          (Item.fromUri(name, secret, ""), [issuerParams, issuerSegments]));
    }

    issuer = issuerSegments.isNotEmpty ? issuerSegments : issuerParams;
    return right((Item.fromUri(name, secret, issuer), [issuer]));
  }

  static Uri getURI(Item item) {
    final uriBuilder = UriBuilder()
      ..scheme = kScheme
      ..host = "totp";
    final queryParameters = <String, String>{}..addAll({
        'period': "30",
        'secret': item.getSecret(),
        'digits': "6",
        'algorithm': "sha1"
      });

    item.getIssuer().fold(() {
      uriBuilder.path = item.name;
    }, (issuer) {
      uriBuilder.path = "$issuer:${item.name}";
      queryParameters.addAll({'issuer': issuer});
    });
    uriBuilder.queryParameters = queryParameters;

    return uriBuilder.build();
  }

  static bool isValidSecret(String secret) {
    int neededPadding = (8 - secret.length % 8) % 8;
    var paddedStr = secret.padRight(secret.length + neededPadding, '=');

    var regex = RegExp(kSecretPattern);

    if (paddedStr.length % 2 != 0 || !regex.hasMatch(paddedStr)) {
      return false;
    }
    return true;
  }
}
