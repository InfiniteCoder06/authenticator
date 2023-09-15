// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/src/hive_impl.dart';
import 'package:riverpie/riverpie.dart';
import 'package:uuid/uuid.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/hive/hive_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/paths.util.dart';
import 'package:authenticator/modules.dart';
import 'package:authenticator/provider.dart';
import '../../utils/hive.util.dart';

void main() {
  Future<HiveImpl> initHive() async {
    var tempDir = await getTempDir();
    var hive = HiveImpl();
    hive.init(tempDir.path);
    return hive;
  }

  late AppPaths appPaths;
  late RiverpieContainer container;
  late HiveEntryRepository entryRepository;
  final item = Item.initial();
  final items = List.generate(9, (index) {
    final identifier = const Uuid().v4();
    return Item.initial(identifier: identifier);
  });

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var tempDir = await getTempDir();
    var hive = await initHive();
    appPaths = AppPaths();
    appPaths.initTest(tempDir.path);

    container = RiverpieContainer(overrides: [
      appPathsProvider.overrideWithValue(appPaths),
      hiveProvider.overrideWithValue(hive),
    ]);

    entryRepository = container.read(hiveEntryRepoProvider);
    await entryRepository.init();
  });

  test('Basic Test', () async {
    final data = await entryRepository.getAll().run();
    expect(data.isRight(), true);
    expect(data.getRight().toNullable()!, []);
  });

  test('Insert Test', () async {
    await entryRepository.create(item).run();
    final data = await entryRepository.getAll().run();

    expect(data.getOrElse((l) => []).length, 1);
    expect(data.getOrElse((l) => []), [item]);
  });

  test('Insert Many', () async {
    for (var item in items) {
      await entryRepository.create(item).run();
    }
    final data = await entryRepository.getAll().run();

    expect(data.getOrElse((l) => []).length, 10);
  });

  test('Update Item', () async {
    await entryRepository.deleteAll(items).run();

    await entryRepository.update(item.copyWith(name: 'Gmail')).run();
    final updatedItems = await entryRepository.getAll().run();

    expect(updatedItems.getOrElse((l) => []).first.name, 'Gmail');
  });

  tearDownAll(() async {
    await entryRepository.clear();
    await deleteTempDir();
  });
}
