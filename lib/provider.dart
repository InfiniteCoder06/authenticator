// 📦 Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/firebase/firebase_backup_repository.dart';
import 'package:authenticator/core/database/hive/hive_entry_repository.dart';
import 'package:authenticator/core/persistence/persistance.dart';
import 'package:authenticator/core/persistence/security.persistance.dart';
import 'package:authenticator/core/security/security_service.dart';
import 'package:authenticator/modules.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
HivePersistanceProvider hiveStorage(HiveStorageRef ref) =>
    HivePersistanceProvider(
      ref.read(hiveProvider),
      ref.read(appPathsProvider),
    );

@Riverpod(keepAlive: true)
SecurityPersistanceProvider securityStorage(SecurityStorageRef ref) =>
    SecurityPersistanceProvider(
      ref.read(hiveProvider),
      ref.read(appPathsProvider),
      ref.read(secureStorageProvider),
    );

@Riverpod(keepAlive: true)
HiveEntryRepository hiveEntryRepo(HiveEntryRepoRef ref) => HiveEntryRepository(
      ref.read(hiveProvider),
      ref.read(appPathsProvider),
      ref.read(secureStorageProvider),
    );

@Riverpod(keepAlive: true)
FirebaseBackupRepository firebaseBackupRepo(FirebaseBackupRepoRef ref) =>
    FirebaseBackupRepository(
      firestore: ref.read(firestoreProvider),
      storageService: ref.read(hiveStorageProvider),
    );

@Riverpod(keepAlive: true)
SecurityInformations securityInformations(SecurityInformationsRef ref) =>
    SecurityInformations(
      localAuth: ref.read(localAuthProvider),
      storage: ref.read(securityStorageProvider),
    );

@Riverpod(keepAlive: true)
SecurityService securityService(SecurityServiceRef ref) => SecurityService(
      lockInfo: ref.read(securityInformationsProvider),
    );
