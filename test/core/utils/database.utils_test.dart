// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/database.utils.dart';

void main() {
  group('Sync changes', () {
    late DatabaseUtils databaseUtils;

    setUp(() {
      databaseUtils = DatabaseUtils();
    });

    test('No changes on either side', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];
      final cloudEntries = [...localEntries];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1, isEmpty);
      expect(result.$2, isEmpty);
      expect(result.$3, isEmpty);
    });

    test('Changes only on the local side', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 2',
          secret: 'secret3',
        ),
      ];
      final cloudEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1, [localEntries[2]]);
      expect(result.$2, isEmpty);
      expect(result.$3, isEmpty);
    });

    test('Changes only on the cloud side', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];
      final cloudEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
      ];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1, isEmpty);
      expect(result.$2, isEmpty);
      expect(result.$3, [cloudEntries[2]]);
    });

    test('Changes on both sides, no conflicts', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
      ];
      final cloudEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1, [localEntries[2]]);
      expect(result.$2, isEmpty);
      expect(result.$3, [cloudEntries[2]]);
    });

    test('Conflicting items, Cloud item is newer', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
      ];
      final cloudEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Updated Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1.toSet(), {localEntries[2]});
      expect(result.$2, isEmpty);
      expect(result.$3.toSet(), {cloudEntries[1], cloudEntries[2]});
    });

    test('Conflicting items, Local item is newer', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Updated Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
      ];
      final cloudEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1.toSet(), {localEntries[1], localEntries[2]});
      expect(result.$2, isEmpty);
      expect(result.$3.toSet(), {cloudEntries[2]});
    });

    test('Conflicting items, Local item is newer and deleted', () async {
      final localEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Updated Item 2',
          secret: 'secret2',
          deleted: true,
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
      ];
      final cloudEntries = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];

      final data = (
        localEntries.map((e) => e.toJson()).toList(),
        cloudEntries.map((e) => e.toJson()).toList()
      );
      final result = await databaseUtils.syncChanges(data);

      expect(result.$1, [localEntries[2]]);
      expect(result.$2, ['2']);
      expect(result.$3, [cloudEntries[2]]);
    });
  });

  group('Difference With Set', () {
    late DatabaseUtils databaseUtils;

    setUp(() {
      databaseUtils = DatabaseUtils();
    });
    test('Both lists are empty', () {
      final a = <Item>[];
      final b = <Item>[];
      final result = databaseUtils.differenceWithSet(a, b);
      expect(result, isEmpty);
    });

    test('One list is empty', () {
      final a = <Item>[];
      final b = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];
      final result = databaseUtils.differenceWithSet(a, b);
      expect(result, isEmpty);
    });

    test('Both lists have distinct elements', () {
      final a = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];
      final b = [
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];
      final result = databaseUtils.differenceWithSet(a, b);
      expect(result, containsAll(a));
      expect(result, isNot(contains(b[0])));
      expect(result, isNot(contains(b[1])));
    });

    test('Both lists have some common elements', () {
      final a = [
        Item(
          identifier: '1',
          createdTime: DateTime(2023, 1, 1),
          updatedTime: DateTime(2023, 1, 1),
          name: 'Item 1',
          secret: 'secret1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];
      final b = [
        Item(
          identifier: '2',
          createdTime: DateTime(2023, 1, 2),
          updatedTime: DateTime(2023, 1, 2),
          name: 'Item 2',
          secret: 'secret2',
        ),
        Item(
          identifier: '3',
          createdTime: DateTime(2023, 1, 3),
          updatedTime: DateTime(2023, 1, 3),
          name: 'Item 3',
          secret: 'secret3',
        ),
        Item(
          identifier: '4',
          createdTime: DateTime(2023, 1, 4),
          updatedTime: DateTime(2023, 1, 4),
          name: 'Item 4',
          secret: 'secret4',
        ),
      ];
      final result1 = databaseUtils.differenceWithSet(a, b);
      expect(result1, contains(a[0]));
      expect(result1, isNot(contains(a[1])));
      expect(result1, isNot(contains(a[2])));

      final result2 = databaseUtils.differenceWithSet(b, a);
      expect(result2, contains(b[1]));
    });
  });
}
