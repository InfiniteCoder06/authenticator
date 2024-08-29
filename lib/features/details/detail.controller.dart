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
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/validator.util.dart';
import 'package:authenticator/provider.dart';

part 'detail.state.dart';

final detailController = ChangeNotifierProvider.autoDispose(
    (ref) => DetailController(ref.read(entryRepoProvider)));

class DetailController extends ChangeNotifier with ConsoleMixin {
  DetailController(this.repository);

  Option<Item> originalItem = none();
  bool isUrl = false;
  bool isLoading = true;
  bool saved = false;
  bool get isNotDirty => saved || !form.dirty && !isUrl;

  Future<void> initialize(Option<Item> item, bool isUrl) async {
    await Future.delayed(Durations.short1);
    this.isUrl = isUrl;
    item.fold(
      () async => _loadTemplate(),
      (item) async => _generateTemplate(item),
    );
    console.info("⚙️ Initialize");
  }

  final BaseEntryRepository repository;

  final form = fb.group({
    'name': fb.control<String>('', [Validators.required]),
    'secret':
        fb.control<String>('', [Validators.required, const Base32Validator()]),
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

  Future<void> save(BuildContext context) async {
    form.markAllAsTouched();
    if (!form.valid) return;

    final newItem = originalItem.toNullable()!.copyWith(
          name: form.value.extract<String>('name').toNullable()?.trim(),
          secret: form.value
              .extract<String>('secret')
              .toNullable()
              ?.replaceAll(" ", "")
              .trim(),
          issuer: form.value.extract<String>('issuer').toNullable()?.trim(),
        );

    await repository.create(newItem);
    saved = true;
    if (context.mounted) {
      Navigator.maybePop<bool>(context, true);
    }
  }

  Future<bool> popRequest(BuildContext context) async {
    if (isNotDirty) return true;
    final canPop = (await showDialog(
          context: context,
          routeSettings: const RouteSettings(name: 'UnsavedChangesDialog'),
          builder: (context) {
            return AlertDialog(
              title: const Text('Unsaved Changes'),
              content: const Text('You have unsaved changes'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Discard'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                )
              ],
            );
          },
        )) ??
        false;

    return canPop;
  }

  @override
  void dispose() {
    originalItem = none();
    form.dispose();
    super.dispose();
  }
}
