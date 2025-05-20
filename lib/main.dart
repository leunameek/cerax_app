import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cerax_app_v1/core/models/plant_record.dart';
import 'package:cerax_app_v1/core/models/sensor_data.dart';
import 'package:cerax_app_v1/presentation/pages/main_navigation_page.dart';
import 'package:cerax_app_v1/presentation/pages/interactive_welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PlantRecordAdapter());
  Hive.registerAdapter(SensorDataAdapter());

  await Hive.openBox<PlantRecord>('plant_history');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuidado de Plantas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Roboto', // Aquí defines Roboto como fuente global
      ),
      home: const InteractiveWelcomePage(),
    );
  }
}
