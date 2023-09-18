// 🎯 Dart imports:
import 'dart:isolate';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:riverpie/riverpie.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_backup_repository.dart';
import 'package:authenticator/core/database/adapter/base_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'account.state.dart';

final accountController = NotifierProvider<AccountController, AccountState>(
    (ref) => AccountController(
        ref.read(firebaseBackupRepoProvider), ref.read(hiveEntryRepoProvider)));

class AccountController extends PureNotifier<AccountState> with ConsoleMixin {
  AccountController(this.backupRepository, this.entryRepository);

  final BaseBackupRepository backupRepository;
  final BaseEntryRepository entryRepository;

  @override
  AccountState init() => AccountState.initial();

  @override
  void postInit() async {
    final cloudChangesDiff = await backupRepository.lastUpdated().run();
    if (cloudChangesDiff.isRight()) {
      state = state.copyWith(cloudUpdated: cloudChangesDiff.toNullable()!);
      console.info("Initialized");
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

    console.debug(
        "Local Items Added : ${cloudChangesDiff.length}, Local Items Updated : ${localSyncItems.length}");
    console.debug(
        "Cloud Items Added : ${localChangesDiff.length}, Cloud Items Updated : ${cloudSyncItems.length}, Cloud Items Deleted : ${deletedIds.length}");

    await backupRepository.backup(
      [...localChangesDiff, ...cloudSyncItems],
      deleteIds: deletedIds,
    ).run();
    await entryRepository
        .createAll([...cloudChangesDiff, ...localSyncItems]).run();
  }

  Future<void> syncChanges() async {
    final localEntries = await entryRepository.getAll().run();
    final cloudEntries = await backupRepository.getAll().run();
    if (localEntries.isRight() && cloudEntries.isRight()) {
      if (kIsWeb) {
        syncChangeIsolate(
            localEntries.toNullable()!, cloudEntries.toNullable()!);
      } else {
        await Isolate.run(() => syncChangeIsolate(
            localEntries.toNullable()!, cloudEntries.toNullable()!));
      }
    }
  }

  Future<void> backup(BuildContext context) async {
    final result =
        await entryRepository.getAll().flatMap(backupRepository.backup).run();

    result.fold(
        (l) => state, (time) => state = AccountState.success(time, time));
  }

  List<T> differenceWithSet<T>(List<T> a, List<T> b) {
    return a.toSet().difference(b.toSet()).toList();
  }
}
