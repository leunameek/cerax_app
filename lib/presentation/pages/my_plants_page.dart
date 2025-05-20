import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cerax_app_v1/core/models/plant_record.dart';
import 'package:cerax_app_v1/presentation/pages/plant_history_page.dart';

class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PlantRecord>('plant_history');
    final records = box.values.toList();

    final Map<String, List<PlantRecord>> groupedByPlant = {};

    for (var record in records) {
      groupedByPlant.putIfAbsent(record.plantName, () => []).add(record);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text("Mis Plantas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body:
          groupedByPlant.isEmpty
              ? const Center(
                child: Text(
                  "No hay datos aún 🌱",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView(
                padding: const EdgeInsets.all(16),
                children:
                    groupedByPlant.entries.map((entry) {
                      final latest = entry.value.last.timestamp;
                      return Card(
                        color: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Última medición: ${latest.day}/${latest.month}/${latest.year}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PlantHistoryPage(
                                      plantName: entry.key,
                                      records: entry.value,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
              ),
    );
  }
}
