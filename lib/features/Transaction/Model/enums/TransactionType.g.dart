// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransactionType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.ALL;
      case 1:
        return TransactionType.EXPENSE;
      case 2:
        return TransactionType.INCOME;
      case 3:
        return TransactionType.TRANSFER;
      case 4:
        return TransactionType.DEBIT;
      case 5:
        return TransactionType.CREDIT;
      case 6:
        return TransactionType.LOAN;
      case 7:
        return TransactionType.LOAN_INTEREST;
      case 8:
        return TransactionType.RECURRING;
      case 9:
        return TransactionType.NONE;
      default:
        return TransactionType.ALL;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.ALL:
        writer.writeByte(0);
        break;
      case TransactionType.EXPENSE:
        writer.writeByte(1);
        break;
      case TransactionType.INCOME:
        writer.writeByte(2);
        break;
      case TransactionType.TRANSFER:
        writer.writeByte(3);
        break;
      case TransactionType.DEBIT:
        writer.writeByte(4);
        break;
      case TransactionType.CREDIT:
        writer.writeByte(5);
        break;
      case TransactionType.LOAN:
        writer.writeByte(6);
        break;
      case TransactionType.LOAN_INTEREST:
        writer.writeByte(7);
        break;
      case TransactionType.RECURRING:
        writer.writeByte(8);
        break;
      case TransactionType.NONE:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
