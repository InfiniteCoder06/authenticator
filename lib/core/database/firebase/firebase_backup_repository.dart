// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_backup_repository.dart';
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';

class FirebaseBackupRepository extends BaseBackupRepository with ConsoleMixin {
  FirebaseFirestore firestore;
  StorageService storageService;

  FirebaseBackupRepository({
    required this.firestore,
    required this.storageService,
  });

  @override
  Future<int> backup(List<Item> items,
      {required String userId, List<String>? deleteIds}) async {
    try {
      deleteIds = deleteIds ?? [];
      final batch = firestore.batch();
      final userDb = firestore.collection(userId);
      final dbModel = userDb.doc("app").collection("items");

      for (var item in items) {
        var docRef = dbModel.doc(item.identifier);
        batch.set(docRef, item.toMap());
      }

      for (var deleteId in deleteIds) {
        var docRef = dbModel.doc(deleteId);
        batch.delete(docRef);
      }
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      await batch.commit();
      await storageService.put(kLocalSync, currentTime);
      return currentTime;
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<int> lastUpdated() async {
    try {
      final data =
          await storageService.get(kLocalSync, defaultValue: 1139941800000);
      return data;
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }

  @override
  Future<List<Item>> getAll(String userId) async {
    try {
      final userDb = firestore.collection(userId);
      final dbModel = userDb.doc("app").collection("items");
      final data = await dbModel.get();
      final items = data.docs.map((doc) => Item.fromMap(doc.data())).toList();
      return items;
    } catch (e) {
      console.error("🔴 $e");
      return Future.error(e);
    }
  }
}
