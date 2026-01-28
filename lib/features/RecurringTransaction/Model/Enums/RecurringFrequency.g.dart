// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecurringFrequency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringFrequencyAdapter extends TypeAdapter<RecurringFrequency> {
  @override
  final int typeId = 11;

  @override
  RecurringFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return RecurringFrequency.weekly;
      case 2:
        return RecurringFrequency.monthly;
      case 3:
        return RecurringFrequency.yearly;
      case 4:
        return RecurringFrequency.daily;
      case 5:
        return RecurringFrequency.none;
      default:
        return RecurringFrequency.weekly;
    }
  }

  @override
  void write(BinaryWriter writer, RecurringFrequency obj) {
    switch (obj) {
      case RecurringFrequency.weekly:
        writer.writeByte(1);
        break;
      case RecurringFrequency.monthly:
        writer.writeByte(2);
        break;
      case RecurringFrequency.yearly:
        writer.writeByte(3);
        break;
      case RecurringFrequency.daily:
        writer.writeByte(4);
        break;
      case RecurringFrequency.none:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
