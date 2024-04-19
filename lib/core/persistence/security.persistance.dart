// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/security/security_object.dart';
import 'package:authenticator/core/types/lock.type.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/paths.util.dart';

class SecurityPersistanceProvider extends StorageService with ConsoleMixin {
  HiveInterface hive;
  Box? _box;

  SecurityPersistanceProvider(this.hive);

  String kLockType = 'lockType';
  String kLockSecret = 'lockSecret';

  @override
  Future<void> init() async {
    const secureStorage = FlutterSecureStorage();
    final encryptionKeyString = await secureStorage.read(key: 'key');
    if (encryptionKeyString == null) {
      final key = hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64Url.encode(key),
      );
    }
    final key = await secureStorage.read(key: 'key');
    final encryptionKeyUint8List = base64Url.decode(key!);
    _box = await hive.openBox(
      kSecurityPreferences,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
      path: AppPaths.hivePath,
    );

    console.info("⚙️ Initialize");
  }

  Future<void> setLock({required LockType type, String? secret}) async {
    await put(kLockType, type.index);
    if (secret != null) {
      await put(kLockSecret, secret);
    }
  }

  Future<SecurityObject> getLock() async {
    final lockInt =
        await get<int>(kLockType, defaultValue: LockType.none.index);
    LockType lock = LockType.values[lockInt];
    String secret = await get<String>(kLockSecret, defaultValue: '');
    switch (lock) {
      case LockType.none:
        return SecurityObject(LockType.none, '');
      case LockType.pin:
        if (secret.isEmpty) return SecurityObject(LockType.none, '');
        return SecurityObject(lock, secret);
      case LockType.biometrics:
        if (secret.isEmpty) return SecurityObject(LockType.none, '');
        return SecurityObject(lock, secret);
    }
  }

  @override
  Future<void> put<T>(String key, T value) async {
    await _box?.put(key, value);
  }

  @override
  Future<T> get<T>(String key, {T? defaultValue}) async {
    return await _box?.get(key, defaultValue: defaultValue) as T;
  }

  @override
  Future<void> clear() async {
    _box?.clear();
  }

  @override
  Future<void> purge() async {
    _box?.deleteFromDisk();
  }

  @override
  Future<void> close() async {
    _box?.close();
  }
}
