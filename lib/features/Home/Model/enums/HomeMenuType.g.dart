// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeMenuType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeMenuTypeAdapter extends TypeAdapter<HomeMenuType> {
  @override
  final int typeId = 12;

  @override
  HomeMenuType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HomeMenuType.NULL;
      case 1:
        return HomeMenuType.HOME_PAGE_BANNER;
      case 2:
        return HomeMenuType.BUDGETS;
      case 3:
        return HomeMenuType.UPCOMING_TRANSACTION;
      case 4:
        return HomeMenuType.GOALS;
      case 5:
        return HomeMenuType.ACCOUNT_LIST;
      case 6:
        return HomeMenuType.INCOME_EXPENSE;
      case 7:
        return HomeMenuType.NET_WORTH;
      case 8:
        return HomeMenuType.LOANS;
      case 9:
        return HomeMenuType.GRAPHS;
      case 10:
        return HomeMenuType.TRANSACTION_LIST;
      default:
        return HomeMenuType.NULL;
    }
  }

  @override
  void write(BinaryWriter writer, HomeMenuType obj) {
    switch (obj) {
      case HomeMenuType.NULL:
        writer.writeByte(0);
        break;
      case HomeMenuType.HOME_PAGE_BANNER:
        writer.writeByte(1);
        break;
      case HomeMenuType.BUDGETS:
        writer.writeByte(2);
        break;
      case HomeMenuType.UPCOMING_TRANSACTION:
        writer.writeByte(3);
        break;
      case HomeMenuType.GOALS:
        writer.writeByte(4);
        break;
      case HomeMenuType.ACCOUNT_LIST:
        writer.writeByte(5);
        break;
      case HomeMenuType.INCOME_EXPENSE:
        writer.writeByte(6);
        break;
      case HomeMenuType.NET_WORTH:
        writer.writeByte(7);
        break;
      case HomeMenuType.LOANS:
        writer.writeByte(8);
        break;
      case HomeMenuType.GRAPHS:
        writer.writeByte(9);
        break;
      case HomeMenuType.TRANSACTION_LIST:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeMenuTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
