// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
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

    _box = await hive.openBox(kDatabase, path: AppPaths.hivePath);
    console.info('Initialize');
  }

  @override
  TaskEither<String, List<Item>> getAll() => TaskEither.tryCatch(
        () async {
          return _box!.values.toList();
        },
        (error, _) {
          console.error(error.toString());
          return error.toString();
        },
      );

  @override
  TaskEither<String, Unit> create(Item item) => TaskEither.tryCatch(
        () async {
          await _box?.put(item.identifier, item);
          console.debug("Saved");
          return unit;
        },
        (error, _) {
          console.error(error.toString());
          return error.toString();
        },
      );

  @override
  TaskEither<String, Unit> delete(Item item) => TaskEither.tryCatch(
        () async {
          await _box?.delete(item.identifier);
          return unit;
        },
        (error, _) {
          console.error(error.toString());
          return error.toString();
        },
      );

  @override
  TaskEither<String, Unit> deleteAll(List<Item> items) => TaskEither.tryCatch(
        () async {
          final keys = items.map((item) => item.identifier);
          await _box?.deleteAll(keys);
          return unit;
        },
        (error, _) {
          console.error(error.toString());
          return error.toString();
        },
      );

  @override
  TaskEither<String, Unit> update(Item item) => TaskEither.tryCatch(
        () async {
          await _box?.put(item.identifier, item);
          return unit;
        },
        (error, _) {
          console.error(error.toString());
          return error.toString();
        },
      );

  @override
  Future<void> clear() async {
    await _box?.deleteFromDisk();
  }
}
