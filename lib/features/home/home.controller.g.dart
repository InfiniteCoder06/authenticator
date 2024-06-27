// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$showBackupNotiHash() => r'b4506de9eae593a66366ec459cdab884951cbd15';

/// See also [showBackupNoti].
@ProviderFor(showBackupNoti)
final showBackupNotiProvider = AutoDisposeFutureProvider<void>.internal(
  showBackupNoti,
  name: r'showBackupNotiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showBackupNotiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ShowBackupNotiRef = AutoDisposeFutureProviderRef<void>;
String _$getAllItemHash() => r'fc8331c9a862f11a78fcd54b21bc9da26bcaf90b';

/// See also [getAllItem].
@ProviderFor(getAllItem)
final getAllItemProvider = AutoDisposeFutureProvider<void>.internal(
  getAllItem,
  name: r'getAllItemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllItemRef = AutoDisposeFutureProviderRef<void>;
String _$filteredItemsHash() => r'1603fb3edb5e208317b46503f64802749912c4ee';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredItems].
@ProviderFor(filteredItems)
const filteredItemsProvider = FilteredItemsFamily();

/// See also [filteredItems].
class FilteredItemsFamily extends Family<List<Item>> {
  /// See also [filteredItems].
  const FilteredItemsFamily();

  /// See also [filteredItems].
  FilteredItemsProvider call(
    String searchText,
  ) {
    return FilteredItemsProvider(
      searchText,
    );
  }

  @override
  FilteredItemsProvider getProviderOverride(
    covariant FilteredItemsProvider provider,
  ) {
    return call(
      provider.searchText,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredItemsProvider';
}

/// See also [filteredItems].
class FilteredItemsProvider extends AutoDisposeProvider<List<Item>> {
  /// See also [filteredItems].
  FilteredItemsProvider(
    String searchText,
  ) : this._internal(
          (ref) => filteredItems(
            ref as FilteredItemsRef,
            searchText,
          ),
          from: filteredItemsProvider,
          name: r'filteredItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredItemsHash,
          dependencies: FilteredItemsFamily._dependencies,
          allTransitiveDependencies:
              FilteredItemsFamily._allTransitiveDependencies,
          searchText: searchText,
        );

  FilteredItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchText,
  }) : super.internal();

  final String searchText;

  @override
  Override overrideWith(
    List<Item> Function(FilteredItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredItemsProvider._internal(
        (ref) => create(ref as FilteredItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchText: searchText,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Item>> createElement() {
    return _FilteredItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredItemsProvider && other.searchText == searchText;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchText.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredItemsRef on AutoDisposeProviderRef<List<Item>> {
  /// The parameter `searchText` of this provider.
  String get searchText;
}

class _FilteredItemsProviderElement
    extends AutoDisposeProviderElement<List<Item>> with FilteredItemsRef {
  _FilteredItemsProviderElement(super.provider);

  @override
  String get searchText => (origin as FilteredItemsProvider).searchText;
}

String _$selectedEntriesHash() => r'a875bbbc053e7060d4af5d98009d545278717ab4';

/// See also [SelectedEntries].
@ProviderFor(SelectedEntries)
final selectedEntriesProvider =
    AutoDisposeNotifierProvider<SelectedEntries, List<Item>>.internal(
  SelectedEntries.new,
  name: r'selectedEntriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedEntriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedEntries = AutoDisposeNotifier<List<Item>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
