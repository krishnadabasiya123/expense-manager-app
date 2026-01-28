// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeMenuItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeMenuItemAdapter extends TypeAdapter<HomeMenuItem> {
  @override
  final int typeId = 13;

  @override
  HomeMenuItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeMenuItem(
      id: fields[0] as int,
      iconCode: fields[1] as int,
      title: fields[2] as String,
      type: fields[4] as HomeMenuType,
      isOn: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HomeMenuItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.iconCode)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.isOn)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeMenuItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
