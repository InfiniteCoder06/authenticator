// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FieldCWProxy {
  Field identifier(String identifier);

  Field type(String type);

  Field reserved(bool reserved);

  Field required(bool required);

  Field readOnly(bool readOnly);

  Field data(FieldData data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Field(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Field(...).copyWith(id: 12, name: "My name")
  /// ````
  Field call({
    String? identifier,
    String? type,
    bool? reserved,
    bool? required,
    bool? readOnly,
    FieldData? data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfField.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfField.copyWith.fieldName(...)`
class _$FieldCWProxyImpl implements _$FieldCWProxy {
  const _$FieldCWProxyImpl(this._value);

  final Field _value;

  @override
  Field identifier(String identifier) => this(identifier: identifier);

  @override
  Field type(String type) => this(type: type);

  @override
  Field reserved(bool reserved) => this(reserved: reserved);

  @override
  Field required(bool required) => this(required: required);

  @override
  Field readOnly(bool readOnly) => this(readOnly: readOnly);

  @override
  Field data(FieldData data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Field(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Field(...).copyWith(id: 12, name: "My name")
  /// ````
  Field call({
    Object? identifier = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? reserved = const $CopyWithPlaceholder(),
    Object? required = const $CopyWithPlaceholder(),
    Object? readOnly = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return Field(
      identifier:
          identifier == const $CopyWithPlaceholder() || identifier == null
              ? _value.identifier
              // ignore: cast_nullable_to_non_nullable
              : identifier as String,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      reserved: reserved == const $CopyWithPlaceholder() || reserved == null
          ? _value.reserved
          // ignore: cast_nullable_to_non_nullable
          : reserved as bool,
      required: required == const $CopyWithPlaceholder() || required == null
          ? _value.required
          // ignore: cast_nullable_to_non_nullable
          : required as bool,
      readOnly: readOnly == const $CopyWithPlaceholder() || readOnly == null
          ? _value.readOnly
          // ignore: cast_nullable_to_non_nullable
          : readOnly as bool,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as FieldData,
    );
  }
}

extension $FieldCopyWith on Field {
  /// Returns a callable class that can be used as follows: `instanceOfField.copyWith(...)` or like so:`instanceOfField.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FieldCWProxy get copyWith => _$FieldCWProxyImpl(this);
}

abstract class _$FieldDataCWProxy {
  FieldData label(String? label);

  FieldData hint(String? hint);

  FieldData value(String? value);

  FieldData extra(Map<String, dynamic>? extra);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FieldData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FieldData(...).copyWith(id: 12, name: "My name")
  /// ````
  FieldData call({
    String? label,
    String? hint,
    String? value,
    Map<String, dynamic>? extra,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFieldData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFieldData.copyWith.fieldName(...)`
class _$FieldDataCWProxyImpl implements _$FieldDataCWProxy {
  const _$FieldDataCWProxyImpl(this._value);

  final FieldData _value;

  @override
  FieldData label(String? label) => this(label: label);

  @override
  FieldData hint(String? hint) => this(hint: hint);

  @override
  FieldData value(String? value) => this(value: value);

  @override
  FieldData extra(Map<String, dynamic>? extra) => this(extra: extra);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FieldData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FieldData(...).copyWith(id: 12, name: "My name")
  /// ````
  FieldData call({
    Object? label = const $CopyWithPlaceholder(),
    Object? hint = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? extra = const $CopyWithPlaceholder(),
  }) {
    return FieldData(
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String?,
      hint: hint == const $CopyWithPlaceholder()
          ? _value.hint
          // ignore: cast_nullable_to_non_nullable
          : hint as String?,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String?,
      extra: extra == const $CopyWithPlaceholder()
          ? _value.extra
          // ignore: cast_nullable_to_non_nullable
          : extra as Map<String, dynamic>?,
    );
  }
}

extension $FieldDataCopyWith on FieldData {
  /// Returns a callable class that can be used as follows: `instanceOfFieldData.copyWith(...)` or like so:`instanceOfFieldData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FieldDataCWProxy get copyWith => _$FieldDataCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FieldAdapter extends TypeAdapter<Field> {
  @override
  final int typeId = 1;

  @override
  Field read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Field(
      identifier: fields[0] as String,
      type: fields[1] as String,
      reserved: fields[2] as bool,
      required: fields[3] as bool,
      readOnly: fields[4] as bool,
      data: fields[5] as FieldData,
    );
  }

  @override
  void write(BinaryWriter writer, Field obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.identifier)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.reserved)
      ..writeByte(3)
      ..write(obj.required)
      ..writeByte(4)
      ..write(obj.readOnly)
      ..writeByte(5)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FieldDataAdapter extends TypeAdapter<FieldData> {
  @override
  final int typeId = 2;

  @override
  FieldData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldData(
      label: fields[0] as String?,
      hint: fields[1] as String?,
      value: fields[2] as String?,
      extra: (fields[4] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FieldData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.hint)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.extra);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      identifier: json['identifier'] as String? ?? '',
      type: json['type'] as String,
      reserved: json['reserved'] as bool? ?? false,
      required: json['required'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      data: FieldData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'type': instance.type,
      'reserved': instance.reserved,
      'required': instance.required,
      'readOnly': instance.readOnly,
      'data': instance.data,
    };

FieldData _$FieldDataFromJson(Map<String, dynamic> json) => FieldData(
      label: json['label'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
      value: json['value'] as String? ?? '',
      extra: json['extra'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$FieldDataToJson(FieldData instance) => <String, dynamic>{
      'label': instance.label,
      'hint': instance.hint,
      'value': instance.value,
      'extra': instance.extra,
    };
