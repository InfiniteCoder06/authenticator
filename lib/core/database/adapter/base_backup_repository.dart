// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

abstract class BaseBackupRepository {
  TaskEither<String, int> lastUpdated();
  TaskEither<String, int> backup(List<Item> items, {List<String>? deleteIds});
  TaskEither<String, List<Item>> getAll();
}
