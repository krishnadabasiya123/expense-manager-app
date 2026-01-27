// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecurringTransactionStatus.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringTransactionStatusAdapter
    extends TypeAdapter<RecurringTransactionStatus> {
  @override
  final int typeId = 10;

  @override
  RecurringTransactionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurringTransactionStatus.PAID;
      case 1:
        return RecurringTransactionStatus.UPCOMING;
      case 2:
        return RecurringTransactionStatus.CANCELLED;
      default:
        return RecurringTransactionStatus.PAID;
    }
  }

  @override
  void write(BinaryWriter writer, RecurringTransactionStatus obj) {
    switch (obj) {
      case RecurringTransactionStatus.PAID:
        writer.writeByte(0);
        break;
      case RecurringTransactionStatus.UPCOMING:
        writer.writeByte(1);
        break;
      case RecurringTransactionStatus.CANCELLED:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
