// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
  moisture: (json['moisture'] as num).toInt(),
  light: (json['light'] as num).toInt(),
  temperature: (json['temperature'] as num).toDouble(),
);

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      'moisture': instance.moisture,
      'light': instance.light,
      'temperature': instance.temperature,
    };
