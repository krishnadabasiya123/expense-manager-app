// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecurringTransaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringTransactionAdapter extends TypeAdapter<RecurringTransaction> {
  @override
  final int typeId = 9;

  @override
  RecurringTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringTransaction(
      recurringTransactionId: fields[0] as String?,
      transactionId: fields[1] as String?,
      recurringId: fields[2] as String?,
      scheduleDate: fields[3] as String?,
      status: fields[4] as RecurringTransactionStatus?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringTransaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.recurringTransactionId)
      ..writeByte(1)
      ..write(obj.transactionId)
      ..writeByte(2)
      ..write(obj.recurringId)
      ..writeByte(3)
      ..write(obj.scheduleDate)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
