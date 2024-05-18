// 🎯 Dart imports:
import 'dart:io';
import 'dart:typed_data';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/qr.util.dart';

void main() {
  late QrUtils qrUtils;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    qrUtils = QrUtils();
  });

  group('Decode File', () {
    test('Invalid Bytes', () async {
      final result = await qrUtils.decodeFile(Uint8List(0));
      expect(result.isSome(), false);
    });
    test('When file have QR Code', () async {
      final file =
          File(join(Directory.current.path, 'test', 'assets', 'test1.png'));

      final result = await qrUtils.decodeFile(await file.readAsBytes());
      expect(result.isSome(), true);
    });

    test('When file doesnt have QR Code', () async {
      final file =
          File(join(Directory.current.path, 'test', 'assets', 'test2.png'));

      final result = await qrUtils.decodeFile(await file.readAsBytes());
      expect(result.isSome(), false);
    });
  });
}
