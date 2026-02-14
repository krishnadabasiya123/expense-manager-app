// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Budget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 14;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      createdAt: fields[9] as String,
      updatedAt: fields[10] as String,
      budgetId: fields[0] as String,
      budgetName: fields[1] as String,
      amount: fields[2] as double,
      catedoryId: (fields[3] as List).cast<String>(),
      type: fields[4] as TransactionType,
      period: fields[5] as BudgetPeriod,
      startDate: fields[6] as String,
      endDate: fields[7] as String,
      alertPercentage: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.budgetId)
      ..writeByte(1)
      ..write(obj.budgetName)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.catedoryId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.period)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.alertPercentage)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
