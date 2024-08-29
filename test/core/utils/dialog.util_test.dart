// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/src/hive_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/hive/hive_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/persistence/persistance.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/paths.util.dart';
import 'package:authenticator/provider.dart';
import '../../utils/path.util.dart';

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
  group('showDeletionDialog', () {
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

    Future<void> initMock() async {
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

      final persistanceProvider = HivePersistanceProvider(hive, appPaths);

      entryRepository = HiveEntryRepository(
          hive, appPaths, secureStorage, persistanceProvider);
      await entryRepository.init();
    });

    testWidgets('Delete Entry', (tester) async {
      final items = [
        Item(
          identifier: '1',
          createdTime: DateTime.now(),
          updatedTime: DateTime.now(),
          name: 'Item 1',
          secret: 'secret1',
          issuer: 'Issuer 1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime.now(),
          updatedTime: DateTime.now(),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];

      for (var item in items) {
        entryRepository.create(item);
      }
      expect((await entryRepository.getAll()).length, 2);
      expect((await entryRepository.getFiltered()).length, 2);
      expect((await entryRepository.getDeletedEntries()).length, 0);

      // Build the widget tree
      await tester.pumpWidget(
        ProviderScope(
          overrides: [entryRepoProvider.overrideWithValue(entryRepository)],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  return ElevatedButton(
                    onPressed: () async {
                      // Show the deletion dialog
                      final result = await AppDialogs.showDeletionDialog(
                        context,
                        [items.first],
                        ref,
                      );
                      // Perform assertions on the result
                      expect(result, true);
                    },
                    child: const Text('Show Deletion Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap the button to show the deletion dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the dialog content
      expect(find.text('Are you sure you want to delete this entry?'),
          findsOneWidget);
      expect(find.text('This action does not disable 2FA for'), findsOneWidget);
      expect(find.text('• Issuer 1 ( Item 1 )'), findsOneWidget);
      expect(
          find.text(
              'To prevent losing access, make sure that you have disabled 2FA or that you have an alternative way to generate codes for this service.'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Dismiss the dialog
      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      expect((await entryRepository.getAll()).length, 2);
      expect((await entryRepository.getFiltered()).length, 1);
      expect((await entryRepository.getDeletedEntries()).length, 1);
    });

    testWidgets('Cancel', (tester) async {
      final items = [
        Item(
          identifier: '1',
          createdTime: DateTime.now(),
          updatedTime: DateTime.now(),
          name: 'Item 1',
          secret: 'secret1',
          issuer: 'Issuer 1',
        ),
        Item(
          identifier: '2',
          createdTime: DateTime.now(),
          updatedTime: DateTime.now(),
          name: 'Item 2',
          secret: 'secret2',
        ),
      ];

      // Build the widget tree
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                return ElevatedButton(
                  onPressed: () async {
                    // Show the deletion dialog
                    final result = await AppDialogs.showDeletionDialog(
                      context,
                      [items.first],
                      ref,
                    );
                    // Perform assertions on the result
                    expect(result, false);
                  },
                  child: const Text('Show Deletion Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the deletion dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the dialog content
      expect(find.text('Are you sure you want to delete this entry?'),
          findsOneWidget);
      expect(find.text('This action does not disable 2FA for'), findsOneWidget);
      expect(find.text('• Issuer 1 ( Item 1 )'), findsOneWidget);
      expect(
          find.text(
              'To prevent losing access, make sure that you have disabled 2FA or that you have an alternative way to generate codes for this service.'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Dismiss the dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
    });
  });

  group('showErrorDialog', () {
    testWidgets('Default Title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await AppDialogs.showErrorDialog(
                      context, 'This is an error message.');
                },
                child: const Text('Show Deletion Dialog'),
              );
            }),
          ),
        ),
      );

      // Tap the button to show the deletion dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the dialog content
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('This is an error message.'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      // Dismiss the dialog
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
    });

    testWidgets('Custom Title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await AppDialogs.showErrorDialog(
                      context, 'This is an error message.',
                      title: 'Test Title');
                },
                child: const Text('Show Deletion Dialog'),
              );
            }),
          ),
        ),
      );

      // Tap the button to show the deletion dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the dialog content
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('This is an error message.'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      // Dismiss the dialog
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
    });
  });

  group('showManualURIDialog', () {
    testWidgets('Custom Text', (tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                return ElevatedButton(
                  onPressed: () async {
                    // Show the deletion dialog
                    final result =
                        await AppDialogs.showManualURIDialog(context);
                    // Perform assertions on the result
                    expect(result, 'otpauth://...');
                  },
                  child: const Text('Show Deletion Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the deletion dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the dialog content
      expect(find.text('Manual URI'), findsOneWidget);
      expect(find.text('Enter URI'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);

      // Enter text in the TextField
      await tester.enterText(find.byType(TextField), 'otpauth://...');
      await tester.pumpAndSettle();

      // Dismiss the dialog
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
    });
  });

  testWidgets('Cancel', (tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              return ElevatedButton(
                onPressed: () async {
                  // Show the deletion dialog
                  final result = await AppDialogs.showManualURIDialog(context);
                  // Perform assertions on the result
                  expect(result, 'skip');
                },
                child: const Text('Show Deletion Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the deletion dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify the dialog content
    expect(find.text('Manual URI'), findsOneWidget);
    expect(find.text('Enter URI'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Ok'), findsOneWidget);

    // Dismiss the dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });
}
