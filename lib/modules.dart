// ignore_for_file: implementation_imports

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/src/hive_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'modules.g.dart';

@Riverpod(keepAlive: true)
HiveImpl hive(HiveRef ref) => HiveImpl();

@Riverpod(keepAlive: true)
ImagePicker imagePicker(ImagePickerRef ref) => ImagePicker();

@Riverpod(keepAlive: true)
LocalAuthentication localAuth(LocalAuthRef ref) => LocalAuthentication();

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) => FirebaseFirestore.instance;
