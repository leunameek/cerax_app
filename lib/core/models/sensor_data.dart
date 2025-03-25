import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  final int moisture;
  final int light;
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
