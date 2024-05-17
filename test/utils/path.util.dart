// 🎯 Dart imports:
import 'dart:io';
import 'dart:math';

// 📦 Package imports:
import 'package:path/path.dart' as path;

final random = Random();
String tempPath =
    path.join(Directory.current.path, '.dart_tool', 'test', 'tmp');
String assetsPath = path.join(Directory.current.path, 'test', 'assets');

Future<Directory> getTempDir() async {
  var name = random.nextInt(pow(2, 32) as int);
  var dir = Directory(path.join(tempPath, '${name}_tmp'));
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
  await dir.create(recursive: true);
  return dir;
}

Future<void> deleteTempDir(String path) async {
  var dir = Directory(path);
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
}
