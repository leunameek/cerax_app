import 'package:flutter/material.dart';
import 'package:cerax_app_v1/core/utils/plant_loader.dart';
import 'package:cerax_app_v1/core/models/plant.dart';

class PlantListPage extends StatefulWidget {
  const PlantListPage({Key? key}) : super(key: key);

  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  late Future<List<Plant>> _plantFuture;

  @override
  void initState() {
    super.initState();
    _plantFuture = PlantLoader.loadFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona tu planta")),
      body: FutureBuilder<List<Plant>>(
        future: _plantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay plantas disponibles."));
          }

          final plants = snapshot.data!;

          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return ListTile(
                leading: Image.asset(
                  plant.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(plant.plant),
                subtitle: Text(plant.scientificName),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
