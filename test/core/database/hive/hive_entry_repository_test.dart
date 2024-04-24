// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/src/hive_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/hive/hive_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/paths.util.dart';
import '../../../utils/hive.util.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

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
    final identifier = const Uuid().v4();
    return Item.initial(identifier: identifier);
  });

  void initMock() async {
    when(() => secureStorage.containsKey(key: any()))
        .thenAnswer((_) => Future.value(true));
    when(() => secureStorage.read(key: any()))
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

  test('Basic Test', () async {
    final data = await entryRepository.getAll();
    expect(data, []);
  });

  test('Insert Test', () async {
    await entryRepository.create(item);
    final data = await entryRepository.getAll();

    expect(data.length, 1);
    expect(data, [item]);
  });

  test('Insert Many', () async {
    for (var item in items) {
      await entryRepository.create(item);
    }
    final data = await entryRepository.getAll();

    expect(data.length, 10);
  });

  test('Update Item', () async {
    await entryRepository.deleteAll(items);

    await entryRepository.update(item.copyWith(name: 'Gmail'));
    final updatedItems = await entryRepository.getAll();

    expect(updatedItems.first.name, 'Gmail');
  });

  tearDownAll(() async {
    await entryRepository.clear();
    await deleteTempDir();
  });
}
