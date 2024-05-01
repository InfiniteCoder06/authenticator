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
import 'package:authenticator/core/utils/database.utils.dart';
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
      console.error("Error");
    }
  }

  Future<void> syncChanges(String userId) async {
    console.debug("⚙️ Start sync");
    state = state.copyWith(isSyncing: true, syncingState: SyncingState.syncing);

    try {
      final localEntries = (await entryRepository.getAll())
          .map((item) => item.toJson())
          .toList();
      final cloudEntries = (await backupRepository.getAll(state.userId))
          .map((item) => item.toJson())
          .toList();

      final data = await compute(
          DatabaseUtils().syncChanges, (localEntries, cloudEntries));

      // Backup
      await backupData(data.$1, data.$2, data.$3);

      // Restore if UserID Changes
      if (userId != state.userId) {
        restoreData(userId);
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
      console.error("$e");
    }
  }

  Future<void> backupData(List<Item> itemsToBeBackup, List<String> deletedIds,
      List<Item> itemsToBeCreated) async {
    final localDeleted = await entryRepository.getDeletedEntries();
    List<String> deletesIds = [
      ...localDeleted.map((item) => item.identifier),
      ...deletedIds,
    ];
    await backupRepository.backup(itemsToBeBackup,
        userId: state.userId, deleteIds: deletesIds);

    console.debug("🗑️ Cloud Items Deleted : ${deletesIds.length}");

    await entryRepository.createAll(itemsToBeCreated);
    await entryRepository.deleteAll(localDeleted);
  }

  Future<void> restoreData(String userId) async {
    final cloudData = await backupRepository.getAll(userId);

    await entryRepository.clear();
    await entryRepository.createAll(cloudData);
  }
}
