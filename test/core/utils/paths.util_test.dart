// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' show join;

// 🌎 Project imports:
import 'package:authenticator/core/utils/paths.util.dart';
import '../../utils/path.util.dart';

void main() {
  group('AppPaths', () {
    late AppPaths appPaths;
    late Directory tempDir;

    setUp(() async {
      appPaths = AppPaths();
      tempDir = await getTempDir();

      const MethodChannel channel =
          MethodChannel('plugins.flutter.io/path_provider');

      TestWidgetsFlutterBinding.ensureInitialized()
          .defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
        switch (methodCall.method) {
          case 'getApplicationSupportDirectory':
            return tempDir.path;
        }
        return null;
      });
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('Init (Non Web)', () async {
      await appPaths.init();

      expect(appPaths.main, isNotNull);
      expect(appPaths.hive, isNotNull);
      expect(appPaths.temp, isNotNull);

      expect(appPaths.mainPath, equals(tempDir.path));
      expect(appPaths.hivePath, equals(join(tempDir.path, 'hive')));
      expect(appPaths.tempPath, equals(join(tempDir.path, 'temp')));
      expect(appPaths.tempVaultFilePath,
          equals(join(join(tempDir.path, 'temp'), 'vault.authenticator')));
    });

    test('Init (Web)', () async {
      await appPaths.init(path: tempDir.path);

      expect(appPaths.main, isNotNull);
      expect(appPaths.hive, isNotNull);
      expect(appPaths.temp, isNotNull);

      expect(appPaths.mainPath, equals(tempDir.path));
      expect(appPaths.hivePath, equals(join(tempDir.path, 'hive')));
      expect(appPaths.tempPath, equals(join(tempDir.path, 'temp')));
      expect(appPaths.tempVaultFilePath,
          equals(join(join(tempDir.path, 'temp'), 'vault.authenticator')));
    });

    test('cleanTemp', () async {
      await appPaths.initTest(tempDir.path);

      final tempFile = File(appPaths.tempVaultFilePath);
      await tempFile.create();

      await appPaths.cleanTemp();

      expect(tempFile.existsSync(), isFalse);
      expect(Directory(appPaths.tempPath).existsSync(), isTrue);
    });
  });
}
