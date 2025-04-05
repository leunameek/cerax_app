import 'package:flutter/material.dart';
import 'package:cerax_app_v1/core/models/plant.dart';
import 'package:cerax_app_v1/core/models/sensor_data.dart';
import 'package:cerax_app_v1/core/services/ble/ble_service.dart';
import 'package:cerax_app_v1/core/utils/sensor_averager.dart';

class PlantAnalyzerPage extends StatefulWidget {
  final Plant plant;
  final BLEService bleService;

  const PlantAnalyzerPage({
    super.key,
    required this.plant,
    required this.bleService,
  });

  @override
  State<PlantAnalyzerPage> createState() => _PlantAnalyzerPageState();
}

class _PlantAnalyzerPageState extends State<PlantAnalyzerPage> {
  bool loading = true;
  SensorData? avgData;
  Map<String, String>? evaluation;

  @override
  void initState() {
    super.initState();
    analyzePlant();
  }

  Future<void> analyzePlant() async {
    final averager = SensorAverager();
    final data = await averager.collectAndAverage(
      widget.bleService.sensorDataStream(),
    );

    final result = widget.plant.evaluateSensorData(data);

    setState(() {
      avgData = data;
      evaluation = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: Text(
          widget.plant.plant,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent),
              )
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Análisis Promedio:",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "🌡️ Temperatura: ${avgData!.temperature}°C\n💧 Humedad: ${avgData!.moisture}%\n🔆 Luz: ${avgData!.light} lux",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Consejos para tu planta:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var entry in evaluation!.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "• ${entry.key}: ${entry.value}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
