import 'package:flutter/material.dart';
import 'package:cerax_app_v1/core/models/plant.dart';
import 'package:cerax_app_v1/core/models/sensor_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cerax_app_v1/core/models/plant_record.dart';
import 'package:cerax_app_v1/core/services/ble/ble_service.dart';
import 'package:cerax_app_v1/core/utils/sensor_averager.dart';

class PlantAnalyzerPage extends StatefulWidget {
  final Plant plant;
  final String nickname; // I added this here but its giving me an error
  final BLEService? bleService;

  const PlantAnalyzerPage({
    super.key,
    required this.plant,
    required this.nickname,
    required this.bleService,
  });

  @override
  State<PlantAnalyzerPage> createState() => _PlantAnalyzerPageState();
}

class _PlantAnalyzerPageState extends State<PlantAnalyzerPage> {
  bool loading = false;
  bool measuring = false;
  SensorData? avgData;
  Map<String, String>? evaluation;

  Future<void> analyzePlant() async {
    if (widget.bleService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conexión BLE no disponible. Conéctate para medir.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    setState(() {
      loading = true;
      avgData = null;
      evaluation = null;
    });

    try {
      final averager = SensorAverager();
      final data = await averager.collectAndAverage(
        widget.bleService!.sensorDataStream(),
      );

      final result = widget.plant.evaluateSensorData(data);

      setState(() {
        avgData = data;
        evaluation = result;
        loading = false;
        measuring = true;
      });

      final record = PlantRecord(
        timestamp: DateTime.now(),
        data: data,
        plantName: widget.plant.plant,
        nickname: widget.nickname,
      );

      final box = Hive.box<PlantRecord>('plant_history');
      await box.add(record);
    } catch (e) {
      setState(() {
        loading = false;
        measuring = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al analizar la planta: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child:
            loading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.bleService == null)
                      const Text(
                        '⚠️ No hay conexión con Cerax!. No se puede medir sin conexión.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else if (!measuring)
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.analytics),
                          label: const Text("Iniciar medición"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff607afb),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: analyzePlant,
                        ),
                      )
                    else ...[
                      Text(
                        "Análisis Promedio:",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "🌡️ Temperatura: ${avgData!.temperature}°C\n💧 Humedad: ${avgData!.moisture}%\n🔆 Luz: ${avgData!.light}%",
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
                  ],
                ),
      ),
    );
  }
}
