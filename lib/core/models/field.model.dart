// ignore_for_file: public_member_api_docs, sort_constructors_first

// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/parsers/field.parsers.dart';

part 'field.model.g.dart';

@JsonSerializable()
@CopyWith()
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

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);

  String get toJsonString => jsonEncode(toJson());

  @override
  List<Object?> get props => [type, reserved, required, data];

  @override
  bool get stringify => true;
}

@JsonSerializable()
@CopyWith()
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

  factory FieldData.fromJson(Map<String, dynamic> json) =>
      _$FieldDataFromJson(json);

  Map<String, dynamic> toJson() => _$FieldDataToJson(this);

  @override
  List<Object?> get props => [value];

  @override
  bool get stringify => true;
}

enum FieldType {
  textField,
  totp,
}
