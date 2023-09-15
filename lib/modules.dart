// ignore_for_file: implementation_imports

// 📦 Package imports:
import 'package:hive/src/hive_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpie/riverpie.dart';

final hiveProvider = Provider((ref) => HiveImpl());
final imagePickerProvider = Provider((ref) => ImagePicker());
final localAuthprovider = Provider((ref) => LocalAuthentication());
