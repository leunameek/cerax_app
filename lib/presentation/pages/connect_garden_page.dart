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

class _ConnectGardenPageState extends State<ConnectGardenPage>
    with TickerProviderStateMixin {
  bool isConnecting = false;
  String? error;

  Future<bool> _showRetryDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            final shakeController = AnimationController(
              vsync: Navigator.of(context),
              duration: const Duration(milliseconds: 400),
            );
            final shakeAnimation = Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.025, 0),
                )
                .chain(CurveTween(curve: Curves.elasticIn))
                .animate(shakeController);

            shakeController.forward().then((_) => shakeController.reverse());

            return SlideTransition(
              position: shakeAnimation,
              child: AlertDialog(
                backgroundColor: const Color(0xFF222222),
                title: const Text(
                  'No se pudo conectar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  'Confirma que Cerax esté encendido y cerca del dispositivo 📡',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Reintentar',
                      style: TextStyle(
                        color: Color(0xff607afb),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  Future<void> _connectToDevice() async {
    setState(() {
      isConnecting = true;
      error = null;
    });

    try {
      final bleService = BLEService();
      await bleService.connectToDevice();
      if (!mounted) return;
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
      if (!mounted) return;

      final retry = await _showRetryDialog();

      setState(() {
        isConnecting = false;
      });

      if (retry) {
        _connectToDevice(); // 💥 Retry logic
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: const Text(
          'Conecta tu jardín',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          Center(
            child: SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff607afb),
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
