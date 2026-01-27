// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String?,
      date: fields[1] as String?,
      title: fields[3] as String?,
      type: fields[4] as TransactionType?,
      amount: fields[5] as double?,
      description: fields[6] as String?,
      categoryId: fields[7] as String?,
      time: fields[2] as String?,
      accountId: fields[8] as String?,
      recurringId: fields[9] as String?,
      accountFromId: fields[10] as String?,
      accountToId: fields[11] as String?,
      image: (fields[12] as List?)?.cast<ImageData>(),
      partyId: fields[13] as String?,
      partyTransactionId: fields[14] as String?,
      addFromType: fields[15] as TransactionType?,
      recurringTransactionId: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.accountId)
      ..writeByte(9)
      ..write(obj.recurringId)
      ..writeByte(10)
      ..write(obj.accountFromId)
      ..writeByte(11)
      ..write(obj.accountToId)
      ..writeByte(12)
      ..write(obj.image)
      ..writeByte(13)
      ..write(obj.partyId)
      ..writeByte(14)
      ..write(obj.partyTransactionId)
      ..writeByte(15)
      ..write(obj.addFromType)
      ..writeByte(16)
      ..write(obj.recurringTransactionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
