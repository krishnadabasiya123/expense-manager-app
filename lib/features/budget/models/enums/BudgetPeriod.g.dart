// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BudgetPeriod.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetPeriodAdapter extends TypeAdapter<BudgetPeriod> {
  @override
  final int typeId = 16;

  @override
  BudgetPeriod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BudgetPeriod.WEEKLY;
      case 1:
        return BudgetPeriod.MONTHLY;
      case 2:
        return BudgetPeriod.YEARLY;
      case 3:
        return BudgetPeriod.CUSTOM;
      default:
        return BudgetPeriod.WEEKLY;
    }
  }

  @override
  void write(BinaryWriter writer, BudgetPeriod obj) {
    switch (obj) {
      case BudgetPeriod.WEEKLY:
        writer.writeByte(0);
        break;
      case BudgetPeriod.MONTHLY:
        writer.writeByte(1);
        break;
      case BudgetPeriod.YEARLY:
        writer.writeByte(2);
        break;
      case BudgetPeriod.CUSTOM:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
