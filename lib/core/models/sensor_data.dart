import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class SensorData {
  @HiveField(0)
  final int moisture;

  @HiveField(1)
  final int light;

  @HiveField(2)
  final double temperature;

  SensorData({
    required this.moisture,
    required this.light,
    required this.temperature,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) =>
      _$SensorDataFromJson(json);

  Map<String, dynamic> toJson() => _$SensorDataToJson(this);
}
