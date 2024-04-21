// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';

class DatabaseUtils with ConsoleMixin {
  Future<(List<Item>, List<String>, List<Item>)> syncChanges(
      (List<Item>, List<Item>) data) async {
    var localEntries = data.$1;
    var cloudEntries = data.$2;
    // Local Changes to to synced to cloud
    final localChangesDiff = differenceWithSet(localEntries, cloudEntries);

    // Cloud Changes to to synced to local
    final cloudChangesDiff = differenceWithSet(cloudEntries, localEntries);

    // Find Similar Items
    final duplicateIds = localChangesDiff
        .map((e) => e.identifier)
        .toSet()
        .intersection(cloudChangesDiff.map((e) => e.identifier).toSet());

    final cloudSyncItems = [];
    final localSyncItems = [];
    final deletedIds = <String>[];

    if (duplicateIds.isNotEmpty) {
      for (var duplicateId in duplicateIds) {
        final localItem =
            localEntries.firstWhere((e) => e.identifier == duplicateId);
        final cloudItem =
            cloudEntries.firstWhere((e) => e.identifier == duplicateId);

        final isLocalItemDeleted = localItem.deleted;

        // Remove Duplicate Items
        localChangesDiff.removeWhere((e) => e.identifier == duplicateId);
        cloudChangesDiff.removeWhere((e) => e.identifier == duplicateId);

        if (cloudItem.updatedTime.isAfter(localItem.updatedTime)) {
          // Cloud Item is Latest
          localSyncItems.add(cloudItem);
        } else {
          // Local Item is Latest
          if (isLocalItemDeleted) {
            deletedIds.add(duplicateId);
          } else {
            cloudSyncItems.add(localItem);
          }
        }
      }
    }

    List<Item> needsToBeBackup = [...localChangesDiff, ...cloudSyncItems];
    List<Item> needsToBeCreated = [...cloudChangesDiff, ...localSyncItems];

    console.debug(
        "➕ Local Items Added : ${cloudChangesDiff.length}, ✏️ Local Items Updated : ${localSyncItems.length}");
    console.debug(
        "➕ Cloud Items Added : ${localChangesDiff.length}, ✏️ Cloud Items Updated : ${cloudSyncItems.length}");

    return (needsToBeBackup, deletedIds, needsToBeCreated);
  }

  List<T> differenceWithSet<T>(List<T> a, List<T> b) {
    return a.toSet().difference(b.toSet()).toList();
  }
}
