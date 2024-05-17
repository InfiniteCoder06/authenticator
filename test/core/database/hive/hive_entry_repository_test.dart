// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/src/hive_impl.dart';
import 'package:mocktail/mocktail.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/hive/hive_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/paths.util.dart';
import '../../../utils/path.util.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {
  @override
  Future<void> write(
      {required String key,
      required String? value,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions,
      WindowsOptions? wOptions}) async {}
}

void main() {
  late List<int> key;
  Future<HiveImpl> initHive() async {
    var tempDir = await getTempDir();
    var hive = HiveImpl();
    key = hive.generateSecureKey();
    hive.init(tempDir.path);
    return hive;
  }

  late AppPaths appPaths;
  late HiveEntryRepository entryRepository;
  final secureStorage = MockSecureStorage();
  final item = Item.initial();
  final items = List.generate(9, (index) {
    var item = Item.initial().copyWith(deleted: index.isEven);
    return item;
  });

  void initMock() async {
    when(() => secureStorage.containsKey(key: 'key'))
        .thenAnswer((_) => Future.value(false));
    when(() => secureStorage.read(key: 'key'))
        .thenAnswer((_) async => base64Encode(key));
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var tempDir = await getTempDir();
    var hive = await initHive();
    appPaths = AppPaths();
    appPaths.initTest(tempDir.path);
    initMock();

    entryRepository = HiveEntryRepository(hive, appPaths, secureStorage);
    await entryRepository.init();
  });

  test('Insert Test', () async {
    await entryRepository.create(item);
    final data = await entryRepository.getAll();

    expect(data.length, 1);
    expect(data, [item]);
  });

  test('Insert Many', () async {
    await entryRepository.createAll(items);
    final data = await entryRepository.getAll();

    expect(data.length, 10);
  });

  test('Get Filtered', () async {
    final data = await entryRepository.getFiltered();
    expect(data.length, 5);
  });

  test('Get Deleted', () async {
    final data = await entryRepository.getDeletedEntries();
    expect(data.length, 5);
  });

  test('Delete Item', () async {
    await entryRepository.delete(item);
    expect((await entryRepository.getAll()).length, 9);
    expect((await entryRepository.getFiltered()).length, 4);
    expect((await entryRepository.getDeletedEntries()).length, 5);
  });

  test('Fake Delete Item', () async {
    await entryRepository.fakeDeleteAll([items.elementAt(1)]);
    expect((await entryRepository.getAll()).length, 9);
    expect((await entryRepository.getFiltered()).length, 3);
    expect((await entryRepository.getDeletedEntries()).length, 6);
  });

  test('Update Item', () async {
    await entryRepository.deleteAll(items);

    await entryRepository.update(item.copyWith(name: 'Gmail'));
    final updatedItems = await entryRepository.getAll();

    expect(updatedItems.first.name, 'Gmail');
  });

  tearDownAll(() async {
    await entryRepository.clear();
    await deleteTempDir(appPaths.tempPath);
  });
}
