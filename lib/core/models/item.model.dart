// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/field.model.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';

part 'item.model.g.dart';

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

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Item.fromMap(data!);
  }

  @override
  List<Object> get props {
    return [
      identifier,
      createdTime,
      updatedTime,
      name,
      iconUrl,
      fields,
      deleted,
    ];
  }

  Item copyWith({
    String? identifier,
    DateTime? createdTime,
    DateTime? updatedTime,
    String? name,
    String? iconUrl,
    List<Field>? fields,
    bool? deleted,
  }) {
    return Item(
      identifier: identifier ?? this.identifier,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      fields: fields ?? this.fields,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'identifier': identifier,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'updatedTime': updatedTime.millisecondsSinceEpoch,
      'name': name,
      'iconUrl': iconUrl,
      'fields': fields.map((x) => x.toMap()).toList(),
      'deleted': deleted,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      identifier: map['identifier'] as String,
      createdTime:
          DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int),
      updatedTime:
          DateTime.fromMillisecondsSinceEpoch(map['updatedTime'] as int),
      name: map['name'] as String,
      iconUrl: map['iconUrl'] as String,
      fields: List<Field>.from(
        map['fields'].map(
          (x) => Field.fromMap(x as Map<String, dynamic>),
        ),
      ),
      deleted: map['deleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
