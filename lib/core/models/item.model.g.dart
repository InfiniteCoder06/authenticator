// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.model.dart';

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
      secret: fields[5] as String,
      issuer: fields[6] as String,
      deleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.secret)
      ..writeByte(6)
      ..write(obj.issuer)
      ..writeByte(7)
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
