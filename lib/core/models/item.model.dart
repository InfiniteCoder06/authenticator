// ignore_for_file: public_member_api_docs, sort_constructors_first

// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/field.model.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';

part 'item.model.g.dart';

@JsonSerializable()
@CopyWith()
@HiveType(typeId: 0)
class Item extends HiveObject with EquatableMixin, ConsoleMixin {
  @HiveField(0)
  String identifier;
  @HiveField(1)
  DateTime createdTime;
  @HiveField(2)
  DateTime updatedTime;
  @HiveField(3)
  String name;
  @HiveField(4)
  String iconUrl;
  @HiveField(5)
  List<Field> fields;
  @HiveField(6)
  bool deleted;

  Item({
    required this.identifier,
    required this.createdTime,
    required this.updatedTime,
    required this.name,
    this.iconUrl = '',
    required this.fields,
    this.deleted = false,
  });

  factory Item.initial({String? identifier}) => Item(
        identifier: identifier ?? const Uuid().v4(),
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        name: '',
        fields: [
          Field(
            identifier: 'secret',
            type: FieldType.totp.name,
            data: FieldData(
              label: 'Secret',
              hint: 'JBSWY3DPEHPK3PXP',
            ),
          ),
          Field(
            identifier: 'issuer',
            type: FieldType.textField.name,
            data: FieldData(
              label: 'Issuer',
              hint: 'Google',
            ),
          )
        ],
      );

  factory Item.fromUri(String name, String secret, String? issuer) => Item(
        identifier: const Uuid().v4(),
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        name: name,
        fields: [
          Field(
            identifier: 'secret',
            type: FieldType.totp.name,
            data: FieldData(
              label: 'Secret',
              hint: 'JBSWY3DPEHPK3PXP',
              value: secret,
            ),
          ),
          Field(
            identifier: 'issuer',
            type: FieldType.textField.name,
            data: FieldData(
              label: 'Issuer',
              hint: 'Google',
              value: issuer,
            ),
          ),
        ],
      );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  String get toJsonString => jsonEncode(toJson());

  @override
  List<Object?> get props => [
        createdTime,
        updatedTime,
        name,
        iconUrl,
        fields,
        deleted,
      ];

  @override
  bool get stringify => true;
}
