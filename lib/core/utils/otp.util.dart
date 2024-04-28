// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:uri/uri.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/core/utils/globals.dart';

class OtpUtils {
  static Either<String, Item> parseURI(Uri uri) {
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
    }

    final List<String> pathSegments = uri.pathSegments;

    if (pathSegments.last.contains(":")) {
      final List<String> strings = uri.pathSegments.last.split(":");
      strings.length == 2
          ? {
              name = strings.elementAt(1),
              issuer = strings.elementAt(0),
            }
          : name = strings.last;
    } else {
      issuer = uri.queryParameters['issuer'] ?? '';
      name = uri.pathSegments.last;
    }

    return right(Item.fromUri(name, secret, issuer));
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
