// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiveStorageHash() => r'd50a7734ad91e8aa0e60735e513b3f10d505e9be';

/// See also [hiveStorage].
@ProviderFor(hiveStorage)
final hiveStorageProvider = Provider<HivePersistanceProvider>.internal(
  hiveStorage,
  name: r'hiveStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hiveStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HiveStorageRef = ProviderRef<HivePersistanceProvider>;
String _$securityStorageHash() => r'401f9bb2205017af099bb36a55f16550778078a5';

/// See also [securityStorage].
@ProviderFor(securityStorage)
final securityStorageProvider = Provider<SecurityPersistanceProvider>.internal(
  securityStorage,
  name: r'securityStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$securityStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecurityStorageRef = ProviderRef<SecurityPersistanceProvider>;
String _$entryRepoHash() => r'c56433ee5c51ce2a90165b5aab686ec6e51177f4';

/// See also [entryRepo].
@ProviderFor(entryRepo)
final entryRepoProvider = Provider<BaseEntryRepository>.internal(
  entryRepo,
  name: r'entryRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$entryRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EntryRepoRef = ProviderRef<BaseEntryRepository>;
String _$firebaseBackupRepoHash() =>
    r'0b59d34b8354919494e7f6c870d464b9afa1658e';

/// See also [firebaseBackupRepo].
@ProviderFor(firebaseBackupRepo)
final firebaseBackupRepoProvider =
    AutoDisposeProvider<FirebaseBackupRepository>.internal(
  firebaseBackupRepo,
  name: r'firebaseBackupRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseBackupRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseBackupRepoRef
    = AutoDisposeProviderRef<FirebaseBackupRepository>;
String _$securityInformationsHash() =>
    r'30c35453a4f01073381b6f71e8e7213312142541';

/// See also [securityInformations].
@ProviderFor(securityInformations)
final securityInformationsProvider =
    AutoDisposeProvider<SecurityInformations>.internal(
  securityInformations,
  name: r'securityInformationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$securityInformationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecurityInformationsRef = AutoDisposeProviderRef<SecurityInformations>;
String _$securityServiceHash() => r'375fe0b693facc502a91e1bcdf3555c153573ef2';

/// See also [securityService].
@ProviderFor(securityService)
final securityServiceProvider = Provider<SecurityService>.internal(
  securityService,
  name: r'securityServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$securityServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecurityServiceRef = ProviderRef<SecurityService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
