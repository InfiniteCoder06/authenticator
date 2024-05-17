// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';

class AppPaths {
  Directory? main;
  Directory? hive;
  Directory? temp;

  String get mainPath => main!.path;
  String get hivePath => hive!.path;
  String get tempPath => temp!.path;

  String get tempVaultFilePath => join(tempPath, kVaultFileName);

  Future<void> init({String? path}) async {
    main = !kIsWeb && path == null
        ? await getApplicationSupportDirectory()
        : Directory(path ?? '');

    hive = Directory(join(main!.path, 'hive'));
    temp = Directory(join(main!.path, 'temp'));

    if (!kIsWeb) {
      await main!.create(recursive: true);
      await hive!.create(recursive: true);
      cleanTemp();
    }

    final console = Console(name: 'AppPaths');
    console.info("🚀 ${main!.path}");
  }

  Future<void> initTest(String path) async {
    main = Directory(path);
    hive = Directory(join(main!.path, 'hive'));
    temp = Directory(join(main!.path, 'temp'));

    if (!kIsWeb) {
      await temp!.create(recursive: true);
      cleanTemp();
    }
  }

  Future<void> cleanTemp() async {
    if (await temp!.exists()) {
      await temp?.delete(recursive: true);
    }

    await temp!.create(recursive: true);
  }
}
