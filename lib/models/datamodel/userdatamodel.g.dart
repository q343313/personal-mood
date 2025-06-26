// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdatamodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataModelAdapter extends TypeAdapter<DataModel> {
  @override
  final int typeId = 1;

  @override
  DataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel(
      daytitle: fields[0] as String,
      bestpoints: fields[1] as String,
      desipoints: fields[2] as String,
      dateTime: fields[3] as DateTime,
      image: fields[4] as String,
      youropiniononday: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.daytitle)
      ..writeByte(1)
      ..write(obj.bestpoints)
      ..writeByte(2)
      ..write(obj.desipoints)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.youropiniononday);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
