import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cerax_app_v1/core/models/plant_record.dart';

class PlantHistoryPage extends StatelessWidget {
  final String plantName;
  final List<PlantRecord> records;

  const PlantHistoryPage({
    super.key,
    required this.plantName,
    required this.records,
  });

  Widget _buildChart(
    String title,
    List<double> values,
    List<DateTime> timestamps,
    Color lineColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: values.reduce((a, b) => a < b ? a : b) - 5,
              maxY: values.reduce((a, b) => a > b ? a : b) + 5,
              backgroundColor: const Color(0xFF1A1A1A),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black87,
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final date = timestamps[spot.x.toInt()];
                      return LineTooltipItem(
                        "${date.day}/${date.month} • ${spot.y.toStringAsFixed(1)}",
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget:
                        (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= timestamps.length)
                        return const SizedBox.shrink();
                      final date = timestamps[index];
                      return Text(
                        "${date.day}/${date.month}",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots:
                      values
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                  isCurved: true,
                  color: lineColor,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timestamps = records.map((e) => e.timestamp).toList();
    final temperatures = records.map((e) => e.data.temperature).toList();
    final moistures = records.map((e) => e.data.moisture.toDouble()).toList();
    final lights = records.map((e) => e.data.light.toDouble()).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: Text(plantName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            records.isEmpty
                ? const Center(
                  child: Text(
                    "No hay registros disponibles.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChart(
                        "🌡️ Temperatura (°C)",
                        temperatures,
                        timestamps,
                        Colors.redAccent,
                      ),
                      _buildChart(
                        "💧 Humedad (%)",
                        moistures,
                        timestamps,
                        Colors.blueAccent,
                      ),
                      _buildChart(
                        "🔆 Luz (%)",
                        lights,
                        timestamps,
                        Colors.amber,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
