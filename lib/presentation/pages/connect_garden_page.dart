import 'package:flutter/material.dart';
import 'package:cerax_app_v1/core/services/ble/ble_service.dart';
import 'package:cerax_app_v1/presentation/pages/plant_analyzer_page.dart';
import 'package:cerax_app_v1/core/models/plant.dart';

class ConnectGardenPage extends StatefulWidget {
  final Plant plant;

  const ConnectGardenPage({super.key, required this.plant});

  @override
  State<ConnectGardenPage> createState() => _ConnectGardenPageState();
}

class _ConnectGardenPageState extends State<ConnectGardenPage> {
  bool isConnecting = false;
  String? error;

  Future<void> _connectToDevice() async {
    setState(() {
      isConnecting = true;
      error = null;
    });

    try {
      final bleService = BLEService();
      await bleService.connectToDevice();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PlantAnalyzerPage(
                plant: widget.plant,
                bleService: bleService,
              ),
        ),
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isConnecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text(
          'Conecta tu jardín',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/connect_garden.png',
            height: 320,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conecta tu jardín',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Empieza conectando tu jardinerito a la aplicación. Una vez que lo hagas, podrás monitorear y controlar las condiciones de tu jardín.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          Center(
            child: SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.bluetooth, color: Colors.white),
                label:
                    isConnecting
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          'Conectar Jardinerito',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                onPressed: isConnecting ? null : _connectToDevice,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
