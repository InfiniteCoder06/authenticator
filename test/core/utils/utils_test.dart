// 🐦 Flutter imports:
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/utils.dart';

void main() {
  test('App Utils Test', () async {
    await AppUtils.copyToClipboard("Test Writing");

    final clipData = await Clipboard.getData('text/plain');
    expect("Test Writing", clipData);
  });
}
