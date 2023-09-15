// 📦 Package imports:
import 'package:riverpie/riverpie.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/hive/hive_entry_repository.dart';
import 'package:authenticator/core/persistence/persistance.dart';
import 'package:authenticator/core/persistence/security.persistance.dart';
import 'package:authenticator/core/security/security_service.dart';
import 'package:authenticator/core/utils/paths.util.dart';
import 'package:authenticator/modules.dart';

final appPathsProvider = Provider((ref) => AppPaths());

final hiveStorageProvider =
    Provider((ref) => HivePersistanceProvider(ref.read(hiveProvider)));

final securityStorageProvider = Provider(
  (ref) => SecurityPersistanceProvider(ref.read(hiveProvider)),
);

final hiveEntryRepoProvider = Provider((ref) =>
    HiveEntryRepository(ref.read(hiveProvider), ref.read(appPathsProvider)));

final securityInformationsProvider = Provider(
  (ref) => SecurityInformations(
    localAuth: ref.read(localAuthprovider),
    storage: ref.read(securityStorageProvider),
  ),
);

final securityServiceProvider = Provider(
    (ref) => SecurityService(lockInfo: ref.read(securityInformationsProvider)));
