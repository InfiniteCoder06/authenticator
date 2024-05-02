// ignore_for_file: implementation_imports

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/src/hive_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/paths.util.dart';

part 'modules.g.dart';

@riverpod
AppPaths appPaths(AppPathsRef ref) => AppPaths();

@riverpod
HiveImpl hive(HiveRef ref) => HiveImpl();

@riverpod
ImagePicker imagePicker(ImagePickerRef ref) => ImagePicker();

@riverpod
LocalAuthentication localAuth(LocalAuthRef ref) => LocalAuthentication();

@riverpod
FirebaseFirestore firestore(FirestoreRef ref) => FirebaseFirestore.instance;

@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) =>
    const FlutterSecureStorage();
