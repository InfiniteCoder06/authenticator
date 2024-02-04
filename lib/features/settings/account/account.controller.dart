// 🎯 Dart imports:
import 'dart:isolate';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_backup_repository.dart';
import 'package:authenticator/core/database/adapter/base_entry_repository.dart';
import 'package:authenticator/core/database/adapter/storage_service.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'account.state.dart';
part 'account.controller.g.dart';

@riverpod
class AccountController extends _$AccountController with ConsoleMixin {
  late final BaseBackupRepository backupRepository;
  late final BaseEntryRepository entryRepository;
  late final StorageService storageService;

  @override
  AccountState build() {
    backupRepository = ref.read(firebaseBackupRepoProvider);
    entryRepository = ref.read(hiveEntryRepoProvider);
    storageService = ref.read(hiveStorageProvider);
    postInit();
    return AccountState.initial();
  }

  void postInit() async {
    try {
      final userId = await storageService.get(kUserId);
      final cloudChangesDiff = await backupRepository.lastUpdated();
      state = state.copyWith(lastSync: cloudChangesDiff, userId: userId);
      console.info("⚙️ Initialize");
    } catch (e) {
      console.error("🔴 Error");
    }
  }

  Future<void> syncChangeIsolate(
      List<Item> localEntries, List<Item> cloudEntries) async {
    // Local Changes to to synced to cloud
    final localChangesDiff = differenceWithSet(localEntries, cloudEntries);

    // Cloud Changes to to synced to local
    final cloudChangesDiff = differenceWithSet(cloudEntries, localEntries);

    final union = {...localChangesDiff, ...cloudChangesDiff}.toList();

    // Find Similar Items
    final duplicateIds = localChangesDiff
        .map((e) => e.identifier)
        .toSet()
        .intersection(cloudChangesDiff.map((e) => e.identifier).toSet());

    final cloudSyncItems = [];
    final localSyncItems = [];
    final deletedIds = <String>[];
    for (var duplicateId in duplicateIds) {
      final localItem = localEntries
          .where((element) => element.identifier == duplicateId)
          .first;
      final cloudItem = cloudEntries
          .where((element) => element.identifier == duplicateId)
          .first;

      final isLocalItemDeleted = localItem.deleted;

      // Remove Duplicate Items
      localChangesDiff
          .removeWhere((element) => element.identifier == duplicateId);
      cloudChangesDiff
          .removeWhere((element) => element.identifier == duplicateId);
      union.removeWhere((element) => element.identifier == duplicateId);

      if (cloudItem.updatedTime.millisecondsSinceEpoch >
          localItem.updatedTime.millisecondsSinceEpoch) {
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

    try {
      final localDeleted = await entryRepository.getDeletedEntries();
      await backupRepository.backup([...localChangesDiff, ...cloudSyncItems],
          userId: state.userId,
          deleteIds: [
            ...localDeleted.map((item) => item.identifier),
            ...deletedIds
          ]);

      await entryRepository.createAll([...cloudChangesDiff, ...localSyncItems]);
      await entryRepository.deleteAll(localDeleted);

      console.debug(
          "➕ Local Items Added : ${cloudChangesDiff.length}, ✏️ Local Items Updated : ${localSyncItems.length}");
      console.debug(
          "➕ Cloud Items Added : ${localChangesDiff.length}, ✏️ Cloud Items Updated : ${cloudSyncItems.length}, 🗑️ Cloud Items Deleted : ${[
        ...localDeleted.map((item) => item.identifier),
        ...deletedIds
      ].length}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncChanges(String userId) async {
    console.debug("⚙️ Start sync");
    state = state.copyWith(isSyncing: true, syncingState: SyncingState.syncing);

    try {
      final localEntries = await entryRepository.getAll();
      final cloudEntries = await backupRepository.getAll(state.userId);

      if (kIsWeb) {
        await syncChangeIsolate(localEntries, cloudEntries);
      } else {
        await Isolate.run(() => syncChangeIsolate(localEntries, cloudEntries));
      }

      if (userId != state.userId) {
        final cloudData = await backupRepository.getAll(userId);

        await entryRepository.clear();
        await entryRepository.createAll(cloudData);
      }

      final currentDate = DateTime.now().millisecondsSinceEpoch;
      await storageService.put(kLocalSync, currentDate);
      state = state.copyWith(userId: userId, lastSync: currentDate);
      await storageService.put(kUserId, userId);
      console.debug("🟢 Successfully Synced");
      state =
          state.copyWith(isSyncing: false, syncingState: SyncingState.success);
    } catch (e) {
      state = state.copyWith(
          isSyncing: false,
          syncingState: SyncingState.error,
          errorMessage: e.toString());
      console.error("🔴 $e");
    }
  }

  List<T> differenceWithSet<T>(List<T> a, List<T> b) {
    return a.toSet().difference(b.toSet()).toList();
  }
}
