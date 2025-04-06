import 'dart:async';
import 'dart:math';
import 'package:cerax_app_v1/core/models/sensor_data.dart';

class FakeBLEService {
  Stream<SensorData> sensorDataStream() {
    final random = Random();
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return SensorData(
        moisture: 50 + random.nextInt(40), // 50–90%
        light: 30 + random.nextInt(60), // 30–90%
        temperature: 18 + random.nextDouble() * 10, // 18–28 °C
      );
    }).take(15); // simulate a 15-second reading session
  }

  Future<void> connectToDevice() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // simulate connection delay
  }
}
