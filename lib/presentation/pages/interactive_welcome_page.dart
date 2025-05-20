import 'package:flutter/material.dart';
import 'package:cerax_app_v1/presentation/pages/plant_list_page.dart';

class InteractiveWelcomePage extends StatefulWidget {
  const InteractiveWelcomePage({super.key});

  @override
  State<InteractiveWelcomePage> createState() => _InteractiveWelcomePageState();
}

class _InteractiveWelcomePageState extends State<InteractiveWelcomePage> with SingleTickerProviderStateMixin {
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
          title: Text(
            'Jardín interactivo',
            style: darkTheme.textTheme.titleLarge?.copyWith(
              color: darkTheme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/garden.png',
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
                    'Bienvenido a tu Jardín Interactivo',
                    style: darkTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: darkTheme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Estamos listos para comenzar. Te guiaremos a través de la configuración y te ayudaremos a cuidar de tus plantas.',
                    style: darkTheme.textTheme.bodyMedium?.copyWith(
                      color: darkTheme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 160,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlantListPage()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Azul medianoche
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Empezar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
