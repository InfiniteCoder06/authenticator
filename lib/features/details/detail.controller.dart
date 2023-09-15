// 🐦 Flutter imports:
import 'package:flutter/material.dart' hide ChangeNotifier;

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:riverpie/riverpie.dart';
import 'package:uuid/uuid.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_entry_repository.dart';
import 'package:authenticator/core/models/field.model.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/utils/extension/string.extension.dart';
import 'package:authenticator/core/utils/globals.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/provider.dart';

part 'detail.state.dart';

final detailController = ChangeNotifierProvider(
    (ref) => DetailController(ref.read(hiveEntryRepoProvider)));

class DetailController extends ChangeNotifier with ConsoleMixin {
  DetailController(this.repository);

  Option<Item> originalItem = none();
  List<Field> fields = [];
  bool isLoading = true;

  Future<void> initialize(Option<Item> item) async {
    item.fold(
      () async => await _loadTemplate(),
      (item) async => _generateTemplate(item),
    );
    console.info("Initialize");
  }

  final BaseEntryRepository repository;

  final form = fb.group({
    'name': fb.control<String>('', [Validators.required]),
    'fields': fb.group({}),
  });

  FormGroup get fieldsGroup => form.control('fields') as FormGroup;

  List<Field> get parseField =>
      fieldsGroup.controls.keys.mapWithIndex((key, index) {
        final itemField = fields.elementAt(index);
        final field = Field(
          identifier: key,
          type: key.type(),
          readOnly: itemField.readOnly,
          required: itemField.required,
          data: FieldData(
            hint: itemField.data.hint,
            label: itemField.data.label,
            value: fieldsGroup.value.extract<String>(key).toNullable(),
          ),
        );

        return field;
      }).toList();

  Future<void> _loadTemplate() async {
    fieldsGroup.addAll(
      {
        'secret': fb.control('',
            [Validators.required, Validators.pattern(RegExp(kSecretPattern))]),
        'issuer': fb.control(''),
      },
    );
    var initialFields = [
      Field(
          identifier: 'secret',
          type: FieldType.totp.name,
          data: FieldData(label: 'Secret', hint: 'JBSWY3DPEHPK3PXP')),
      Field(
          identifier: 'issuer',
          type: FieldType.textField.name,
          data: FieldData(label: 'Issuer', hint: 'Google'))
    ];

    originalItem = some(Item(
      identifier: const Uuid().v4(),
      createdTime: DateTime.now(),
      updatedTime: DateTime.now(),
      name: '',
      fields: initialFields,
    ));

    fields = initialFields;
    isLoading = false;
    notifyListeners();
  }

  Future<void> _generateTemplate(Item item) async {
    form.control('name').value = item.name;

    originalItem = some(item);
    fields = item.fields;
    for (var field in item.fields) {
      fieldsGroup.addAll({
        field.identifier: fb.control(
          field.data.value,
          [
            if (field.required) Validators.required,
            if (field.required) Validators.pattern(RegExp(kSecretPattern))
          ],
        )
      });
    }

    isLoading = false;
    notifyListeners();
  }

  void save(BuildContext context) async {
    form.markAllAsTouched();
    if (!form.valid) return;

    final newItem = originalItem.toNullable()!.copyWith(
          name: form.value.extract<String>('name').toNullable(),
          fields: parseField,
        );

    await repository.create(newItem).run();
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
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  hasChanges = false;
                  Navigator.of(context).pop();
                },
                child: const Text('Discard'),
              ),
            ],
          );
        },
      );
    }

    return !hasChanges;
  }
}
