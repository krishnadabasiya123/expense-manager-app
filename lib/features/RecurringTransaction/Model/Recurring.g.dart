// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Recurring.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringAdapter extends TypeAdapter<Recurring> {
  @override
  final int typeId = 8;

  @override
  Recurring read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recurring(
      recurringId: fields[0] as String,
      title: fields[1] as String,
      frequency: fields[2] as RecurringFrequency,
      startDate: fields[3] as String,
      endDate: fields[4] as String,
      amount: fields[5] as double,
      accountId: fields[6] as String,
      categoryId: fields[7] as String,
      type: fields[8] as TransactionType,
      recurringTransactions: (fields[9] as List).cast<RecurringTransaction>(),
      image: (fields[10] as List).cast<ImageData>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recurring obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.recurringId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.accountId)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.recurringTransactions)
      ..writeByte(10)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
