// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PartyTransaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartyTransactionAdapter extends TypeAdapter<PartyTransaction> {
  @override
  final int typeId = 4;

  @override
  PartyTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartyTransaction(
      id: fields[0] as String,
      date: fields[1] as String,
      type: fields[2] as TransactionType,
      amount: fields[5] as double,
      description: fields[6] as String,
      category: fields[4] as String,
      isMainTransaction: fields[7] as bool,
      accountId: fields[8] as String,
      image: (fields[9] as List).cast<ImageData>(),
      createdAt: fields[10] as String,
      updatedAt: fields[11] as String?,
      mainTransactionId: fields[12] as String,
      partyId: fields[13] as String,
      partyName: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PartyTransaction obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.isMainTransaction)
      ..writeByte(8)
      ..write(obj.accountId)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.mainTransactionId)
      ..writeByte(13)
      ..write(obj.partyId)
      ..writeByte(14)
      ..write(obj.partyName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
