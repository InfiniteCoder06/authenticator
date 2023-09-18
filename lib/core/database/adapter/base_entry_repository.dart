// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

abstract class BaseEntryRepository {
  Future<void> init();
  TaskEither<String, List<Item>> getAll();
  TaskEither<String, List<Item>> getFiltered();
  TaskEither<String, Unit> create(Item item);
  TaskEither<String, Unit> createAll(List<Item> items);
  TaskEither<String, Unit> update(Item item);
  TaskEither<String, Unit> fakeDeleteAll(List<Item> items);
  TaskEither<String, Unit> delete(Item item);
  TaskEither<String, Unit> deleteAll(List<Item> items);
  Future<void> clear();
}
