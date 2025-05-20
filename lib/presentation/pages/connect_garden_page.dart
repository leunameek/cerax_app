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

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _showRetryDialog() async {
    // Mantengo tu código original del diálogo de retry sin cambios
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
                  'Confirma que Cerax esté encendido y cerca del dispositivo ',
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
          builder: (_) => PlantAnalyzerPage(
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
        _connectToDevice();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark();

    return Theme(
      data: darkTheme,
      child: Scaffold(
        backgroundColor: darkTheme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: BackButton(color: darkTheme.colorScheme.onSurface),
          title: Text(
            'Conecta tu jardín',
            style: darkTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTheme.colorScheme.onSurface,
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conecta tu jardín',
                    style: darkTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: darkTheme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Empieza conectando tu jardinerito a la aplicación. Una vez que lo hagas, podrás monitorear y controlar las condiciones de tu jardín.',
                    style: darkTheme.textTheme.bodyMedium?.copyWith(
                      color: darkTheme.colorScheme.onSurface.withAlpha(179),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 220,
                height: 48,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: ScaleTransition(
                    scale: _animation,
                    child: const Icon(Icons.bluetooth, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  label: isConnecting
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
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  onPressed: isConnecting ? null : _connectToDevice,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
