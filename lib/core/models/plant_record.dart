import 'package:hive/hive.dart';
import 'sensor_data.dart';

part 'plant_record.g.dart';

@HiveType(typeId: 0)
class PlantRecord extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final SensorData data;

  @HiveField(2)
  final String plantName;

  PlantRecord({
    required this.timestamp,
    required this.data,
    required this.plantName,
  });
}
