import 'dart:async';
import 'package:cerax_app_v1/core/models/sensor_data.dart';

class SensorAverager {
  final Duration duration;
  final List<SensorData> _samples = [];

  SensorAverager({this.duration = const Duration(seconds: 15)});

  Future<SensorData> collectAndAverage(Stream<SensorData> stream) async {
    final subscription = stream.listen((data) {
      _samples.add(data);
    });

    await Future.delayed(duration);
    await subscription.cancel();

    if (_samples.isEmpty) {
      throw Exception("No data received from sensor.");
    }

    final int n = _samples.length;

    final double avgMoisture =
        _samples.map((e) => e.moisture).reduce((a, b) => a + b) / n;
    final double avgLight =
        _samples.map((e) => e.light).reduce((a, b) => a + b) / n;
    final double avgTemp =
        _samples.map((e) => e.temperature).reduce((a, b) => a + b) / n;

    return SensorData(
      moisture: avgMoisture.round(),
      light: avgLight.round(),
      temperature: double.parse(avgTemp.toStringAsFixed(2)),
    );
  }
}
