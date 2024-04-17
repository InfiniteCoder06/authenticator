// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'detail.state.dart';

final detailController = ChangeNotifierProvider.autoDispose(
    (ref) => DetailController(ref.read(hiveEntryRepoProvider)));

class DetailController extends ChangeNotifier with ConsoleMixin {
  DetailController(this.repository);

  Option<Item> originalItem = none();
  bool isLoading = true;

  Future<void> initialize(Option<Item> item) async {
    await Future.delayed(Durations.short1);
    item.fold(
      () async => await _loadTemplate(),
      (item) async => _generateTemplate(item),
    );
    console.info("⚙️ Initialize");
  }

  final BaseEntryRepository repository;

  final form = fb.group({
    'name': fb.control<String>('', [Validators.required]),
    'secret': fb.control<String>('', [Validators.required, Validators.pattern(RegExp(kSecretPattern))]),
    'issuer': fb.control<String>(''),
  });

  Future<void> _loadTemplate() async {
    originalItem = some(Item.initial());
    isLoading = false;
    notifyListeners();
  }

  Future<void> _generateTemplate(Item item) async {
    form.control('name').value = item.name;
    form.control('secret').value = item.secret;
    form.control('issuer').value = item.issuer;
    originalItem = some(item);

    isLoading = false;
    notifyListeners();
  }

  void save(BuildContext context) async {
    form.markAllAsTouched();
    if (!form.valid) return;

    final newItem = originalItem.toNullable()!.copyWith(
          name: form.value.extract<String>('name').toNullable(),
          secret: form.value.extract<String>('secret').toNullable(),
          issuer: form.value.extract<String>('issuer').toNullable(),
        );

    await repository.create(newItem);
    if (context.mounted) {
      Navigator.of(context).pop(context);
    }
  }

  Future<bool> canPop(BuildContext context) async {
    var hasChanges = form.dirty;
    if (form.dirty) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const SizedBox(
                width: 450, child: Text('You have unsaved changes')),
            actions: [
              TextButton(
                onPressed: () {
                  hasChanges = false;
                  Navigator.of(context).pop();
                },
                child: const Text('Discard'),
              ),
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancel'),
              )
            ],
          );
        },
      );
    }

    return !hasChanges;
  }

  @override
  void dispose() {
    originalItem = none();
    form.dispose();
    super.dispose();
  }
}
