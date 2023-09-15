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

@immutable
class AppPaths {
  static Directory? main;
  static Directory? hive;
  static Directory? temp;

  static String get mainPath => main!.path;
  static String get hivePath => hive!.path;
  static String get tempPath => temp!.path;

  static String get tempVaultFilePath =>
      join(AppPaths.tempPath, kVaultFileName);

  Future<void> init({String? path}) async {
    if (!kIsWeb) {
      main = await getApplicationSupportDirectory();
    } else {
      main = Directory('');
    }

    hive = Directory(join(main!.path, 'hive'));
    temp = Directory(join(main!.path, 'temp'));

    if (!kIsWeb) {
      await main!.create(recursive: true);
      await hive!.create(recursive: true);
      cleanTemp();
    }

    final console = Console(name: 'AppPaths');
    console.info(main!.path);
  }

  Future<void> initTest(String path) async {
    main = Directory('');
    hive = Directory(join(main!.path, 'hive'));
    temp = Directory(join(main!.path, 'temp'));
  }

  static Future<void> cleanTemp() async {
    if (await temp!.exists()) {
      await temp?.delete(recursive: true);
    }

    await temp!.create(recursive: true);
  }
}
