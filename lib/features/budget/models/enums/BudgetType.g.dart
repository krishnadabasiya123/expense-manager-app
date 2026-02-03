// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BudgetType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetTypeAdapter extends TypeAdapter<BudgetType> {
  @override
  final int typeId = 15;

  @override
  BudgetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BudgetType.INCOME;
      case 1:
        return BudgetType.EXPENSE;
      default:
        return BudgetType.INCOME;
    }
  }

  @override
  void write(BinaryWriter writer, BudgetType obj) {
    switch (obj) {
      case BudgetType.INCOME:
        writer.writeByte(0);
        break;
      case BudgetType.EXPENSE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
