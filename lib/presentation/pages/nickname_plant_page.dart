import 'package:flutter/material.dart';
import 'package:cerax_app_v1/core/models/plant.dart';
import 'package:cerax_app_v1/presentation/pages/connect_garden_page.dart';

class NicknamePlantPage extends StatefulWidget {
  final Plant plant;

  const NicknamePlantPage({super.key, required this.plant});

  @override
  State<NicknamePlantPage> createState() => _NicknamePlantPageState();
}

class _NicknamePlantPageState extends State<NicknamePlantPage> {
  final TextEditingController _controller = TextEditingController();

  void _continue() {
    if (_controller.text.trim().isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ConnectGardenPage(
              plant: widget.plant,
              nickname: _controller.text.trim(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text(
          'Asigna un apodo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '¿Cómo quieres llamar a tu ${widget.plant.plant}?',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ej: Orquídea del balcón',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff607afb),
              ),
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
