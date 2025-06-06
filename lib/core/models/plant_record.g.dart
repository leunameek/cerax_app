// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantRecordAdapter extends TypeAdapter<PlantRecord> {
  @override
  final int typeId = 0;

  @override
  PlantRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantRecord(
      timestamp: fields[0] as DateTime,
      data: fields[1] as SensorData,
      plantName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlantRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.plantName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
