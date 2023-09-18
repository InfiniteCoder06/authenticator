// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.model.dart';

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
