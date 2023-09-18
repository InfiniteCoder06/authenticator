// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';

abstract class BaseBackupRepository {
  Future<int> lastUpdated();
  Future<int> backup(List<Item> items,
      {required String userId, List<String>? deleteIds});
  Future<List<Item>> getAll(String userId);
}
