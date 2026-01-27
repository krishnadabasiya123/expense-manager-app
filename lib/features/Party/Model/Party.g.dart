// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Party.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartyAdapter extends TypeAdapter<Party> {
  @override
  final int typeId = 7;

  @override
  Party read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Party(
      createdAt: fields[3] as String,
      updatedAt: fields[4] as String,
      id: fields[0] as String,
      name: fields[1] as String?,
      transaction: (fields[2] as List?)?.cast<PartyTransaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, Party obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.transaction)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
