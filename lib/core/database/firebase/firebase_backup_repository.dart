// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_backup_repository.dart';
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';

class FirebaseBackupRepository extends BaseBackupRepository with ConsoleMixin {
  FirebaseFirestore firestore;
  StorageService storageService;

  FirebaseBackupRepository(
      {required this.firestore, required this.storageService});

  @override
  TaskEither<String, int> backup(List<Item> items, {List<String>? deleteIds}) {
    return TaskEither.tryCatch(() async {
      deleteIds = deleteIds ?? [];
      final batch = firestore.batch();
      final dbModel = firestore.collection("items");

      for (var item in items) {
        var docRef = dbModel.doc(item.identifier);
        batch.set(docRef, item.toMap());
      }

      for (var deleteId in deleteIds!) {
        var docRef = dbModel.doc(deleteId);
        batch.delete(docRef);
      }
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      await batch.commit();
      await storageService.put(kLocalSync, currentTime);
      return currentTime;
    }, (error, _) {
      console.error(error.toString());
      return error.toString();
    });
  }

  @override
  TaskEither<String, int> lastUpdated() {
    return TaskEither.tryCatch(
      () async {
        final data =
            await storageService.get(kLocalSync, defaultValue: 1139941800000);
        return data;
      },
      (error, stackTrace) {
        console.error(error.toString());
        return error.toString();
      },
    );
  }

  @override
  TaskEither<String, List<Item>> getAll() {
    return TaskEither.tryCatch(() async {
      final dbModel = firestore.collection("items");
      final data = await dbModel.get();
      final items = data.docs.map((doc) => Item.fromMap(doc.data())).toList();
      return items;
    }, (error, stackTrace) {
      console.error(error.toString());
      return error.toString();
    });
  }
}
