// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

abstract class BaseEntryRepository {
  Future<void> init();
  Future<List<Item>> getAll();
  Future<List<Item>> getFiltered();
  Future<List<Item>> getDeletedEntries();
  Future<void> create(Item item);
  Future<void> createAll(List<Item> items);
  Future<void> update(Item item);
  Future<void> fakeDeleteAll(List<Item> items);
  Future<void> delete(Item item);
  Future<void> deleteAll(List<Item> items);
  Future<void> clear();
}
