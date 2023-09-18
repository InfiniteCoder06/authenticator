// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

// 🌎 Project imports:
import 'package:authenticator/core/parsers/field.parsers.dart';

part 'field.model.g.dart';

@HiveType(typeId: 1)
class Field extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String identifier;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final bool reserved;
  @HiveField(3)
  final bool required;
  @HiveField(4)
  bool readOnly;
  @HiveField(5)
  FieldData data;

  Field({
    this.identifier = '',
    required this.type,
    this.reserved = false,
    this.required = false,
    this.readOnly = false,
    required this.data,
  });

  Widget get widget => FieldParser.parse(this);

  @override
  List<Object> get props {
    return [
      identifier,
      type,
      reserved,
      required,
      readOnly,
      data,
    ];
  }

  Field copyWith({
    String? identifier,
    String? type,
    bool? reserved,
    bool? required,
    bool? readOnly,
    FieldData? data,
  }) {
    return Field(
      identifier: identifier ?? this.identifier,
      type: type ?? this.type,
      reserved: reserved ?? this.reserved,
      required: required ?? this.required,
      readOnly: readOnly ?? this.readOnly,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'identifier': identifier,
      'type': type,
      'reserved': reserved,
      'required': required,
      'readOnly': readOnly,
      'data': data.toMap(),
    };
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    return Field(
      identifier: map['identifier'] as String,
      type: map['type'] as String,
      reserved: map['reserved'] as bool,
      required: map['required'] as bool,
      readOnly: map['readOnly'] as bool,
      data: FieldData.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Field.fromJson(String source) =>
      Field.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}

@HiveType(typeId: 2)
class FieldData extends HiveObject with EquatableMixin {
  @HiveField(0)
  String? label;
  @HiveField(1)
  String? hint;
  @HiveField(2)
  String? value;
  @HiveField(4)
  Map<String, dynamic>? extra;

  FieldData({
    this.label = '',
    this.hint = '',
    this.value = '',
    this.extra = const {},
  });

  FieldData copyWith({
    String? label,
    String? hint,
    String? value,
    Map<String, dynamic>? extra,
  }) {
    return FieldData(
      label: label ?? this.label,
      hint: hint ?? this.hint,
      value: value ?? this.value,
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'hint': hint,
      'value': value,
      'extra': extra,
    };
  }

  factory FieldData.fromMap(Map<String, dynamic> map) {
    return FieldData(
      label: map['label'] != null ? map['label'] as String : null,
      hint: map['hint'] != null ? map['hint'] as String : null,
      value: map['value'] != null ? map['value'] as String : null,
      extra: map['extra'] != null
          ? Map<String, dynamic>.from((map['extra'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FieldData.fromJson(String source) =>
      FieldData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [label, hint, value, extra];
}

enum FieldType {
  textField,
  totp,
}
