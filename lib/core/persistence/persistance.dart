// 📦 Package imports:
import 'package:hive/hive.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/paths.util.dart';

class HivePersistanceProvider extends StorageService with ConsoleMixin {
  HiveInterface hive;
  Box? _box;

  HivePersistanceProvider(this.hive);

  @override
  Future<void> init() async {
    _box = await hive.openBox(kAppPreferences, path: AppPaths.hivePath);

    console.info("⚙️ Initialize");
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
