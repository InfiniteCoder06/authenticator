// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemCWProxy {
  Item identifier(String identifier);

  Item createdTime(DateTime createdTime);

  Item updatedTime(DateTime updatedTime);

  Item name(String name);

  Item iconUrl(String iconUrl);

  Item fields(List<Field> fields);

  Item deleted(bool deleted);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Item(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Item(...).copyWith(id: 12, name: "My name")
  /// ````
  Item call({
    String? identifier,
    DateTime? createdTime,
    DateTime? updatedTime,
    String? name,
    String? iconUrl,
    List<Field>? fields,
    bool? deleted,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItem.copyWith.fieldName(...)`
class _$ItemCWProxyImpl implements _$ItemCWProxy {
  const _$ItemCWProxyImpl(this._value);

  final Item _value;

  @override
  Item identifier(String identifier) => this(identifier: identifier);

  @override
  Item createdTime(DateTime createdTime) => this(createdTime: createdTime);

  @override
  Item updatedTime(DateTime updatedTime) => this(updatedTime: updatedTime);

  @override
  Item name(String name) => this(name: name);

  @override
  Item iconUrl(String iconUrl) => this(iconUrl: iconUrl);

  @override
  Item fields(List<Field> fields) => this(fields: fields);

  @override
  Item deleted(bool deleted) => this(deleted: deleted);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Item(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Item(...).copyWith(id: 12, name: "My name")
  /// ````
  Item call({
    Object? identifier = const $CopyWithPlaceholder(),
    Object? createdTime = const $CopyWithPlaceholder(),
    Object? updatedTime = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? iconUrl = const $CopyWithPlaceholder(),
    Object? fields = const $CopyWithPlaceholder(),
    Object? deleted = const $CopyWithPlaceholder(),
  }) {
    return Item(
      identifier:
          identifier == const $CopyWithPlaceholder() || identifier == null
              ? _value.identifier
              // ignore: cast_nullable_to_non_nullable
              : identifier as String,
      createdTime:
          createdTime == const $CopyWithPlaceholder() || createdTime == null
              ? _value.createdTime
              // ignore: cast_nullable_to_non_nullable
              : createdTime as DateTime,
      updatedTime:
          updatedTime == const $CopyWithPlaceholder() || updatedTime == null
              ? _value.updatedTime
              // ignore: cast_nullable_to_non_nullable
              : updatedTime as DateTime,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      iconUrl: iconUrl == const $CopyWithPlaceholder() || iconUrl == null
          ? _value.iconUrl
          // ignore: cast_nullable_to_non_nullable
          : iconUrl as String,
      fields: fields == const $CopyWithPlaceholder() || fields == null
          ? _value.fields
          // ignore: cast_nullable_to_non_nullable
          : fields as List<Field>,
      deleted: deleted == const $CopyWithPlaceholder() || deleted == null
          ? _value.deleted
          // ignore: cast_nullable_to_non_nullable
          : deleted as bool,
    );
  }
}

extension $ItemCopyWith on Item {
  /// Returns a callable class that can be used as follows: `instanceOfItem.copyWith(...)` or like so:`instanceOfItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemCWProxy get copyWith => _$ItemCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      identifier: fields[0] as String,
      createdTime: fields[1] as DateTime,
      updatedTime: fields[2] as DateTime,
      name: fields[3] as String,
      iconUrl: fields[4] as String,
      fields: (fields[5] as List).cast<Field>(),
      deleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.identifier)
      ..writeByte(1)
      ..write(obj.createdTime)
      ..writeByte(2)
      ..write(obj.updatedTime)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.iconUrl)
      ..writeByte(5)
      ..write(obj.fields)
      ..writeByte(6)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      identifier: json['identifier'] as String,
      createdTime: DateTime.parse(json['createdTime'] as String),
      updatedTime: DateTime.parse(json['updatedTime'] as String),
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String? ?? '',
      fields: (json['fields'] as List<dynamic>)
          .map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'createdTime': instance.createdTime.toIso8601String(),
      'updatedTime': instance.updatedTime.toIso8601String(),
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'fields': instance.fields,
      'deleted': instance.deleted,
    };
