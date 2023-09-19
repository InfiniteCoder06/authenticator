// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_entry_repository.dart';
import 'package:authenticator/core/models/field.model.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/paths.util.dart';

class HiveEntryRepository extends BaseEntryRepository with ConsoleMixin {
  HiveInterface hive;
  Box<Item>? _box;
  AppPaths paths;

  HiveEntryRepository(this.hive, this.paths);

  @override
  Future<void> init() async {
    hive.registerAdapter(ItemAdapter());
    hive.registerAdapter(FieldAdapter());
    hive.registerAdapter(FieldDataAdapter());

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
      kDatabase,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
      path: AppPaths.hivePath,
    );
    console.info("⚙️ Initialize");
  }

  @override
  Future<void> create(Item item) async {
    try {
      await _box?.put(item.identifier, item);
      console.debug("🛎️ Create: ${item.name}");
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> createAll(List<Item> items) async {
    try {
      for (var item in items) {
        await _box?.put(item.identifier, item);
        console.debug("🛎️ Create: ${item.name}");
      }
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<List<Item>> getAll() async {
    try {
      return _box!.values.toList();
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<List<Item>> getFiltered() async {
    try {
      return _box!.values.where((element) => !element.deleted).toList();
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<List<Item>> getDeletedEntries() async {
    try {
      return _box!.values.where((element) => element.deleted).toList();
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> update(Item item) async {
    try {
      await _box?.put(item.identifier, item);
      console.debug("✏️ Update: ${item.name}");
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> delete(Item item) async {
    try {
      await _box?.delete(item.identifier);
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteAll(List<Item> items) async {
    try {
      final keys = items.map((item) => item.identifier);
      await _box?.deleteAll(keys);
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> fakeDeleteAll(List<Item> items) async {
    try {
      for (var item in items) {
        item = item.copyWith(deleted: true, updatedTime: DateTime.now());
        await _box?.put(item.identifier, item);
        console.debug("🗑️ Delete: ${item.name}");
      }
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> clear() async {
    await _box?.clear();
  }
}
