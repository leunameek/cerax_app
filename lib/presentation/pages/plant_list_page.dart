import 'package:flutter/material.dart';
import 'package:cerax_app_v1/core/utils/plant_loader.dart';
import 'package:cerax_app_v1/core/models/plant.dart';
import 'package:cerax_app_v1/presentation/pages/connect_garden_page.dart';

class PlantListPage extends StatefulWidget {
  const PlantListPage({super.key});

  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

<<<<<<< HEAD
class _PlantListPageState extends State<PlantListPage> with SingleTickerProviderStateMixin {
=======
class _PlantListPageState extends State<PlantListPage> {
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
  late Future<List<Plant>> _plantFuture;
  List<Plant> _allPlants = [];
  List<Plant> _filteredPlants = [];
  final TextEditingController _searchController = TextEditingController();

<<<<<<< HEAD
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

=======
  @override
  void initState() {
    super.initState();
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
    _plantFuture = PlantLoader.loadFromAssets();
    _plantFuture.then((plants) {
      setState(() {
        _allPlants = plants;
        _filteredPlants = plants;
      });
    });
    _searchController.addListener(_filterPlants);
  }

  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlants =
<<<<<<< HEAD
          _allPlants.where((p) => p.plant.toLowerCase().contains(query)).toList();
=======
          _allPlants
              .where((p) => p.plant.toLowerCase().contains(query))
              .toList();
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
    });
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _controller.dispose();
=======
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final darkTheme = ThemeData.dark();

    return Theme(
      data: darkTheme,
      child: Scaffold(
        backgroundColor: darkTheme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: darkTheme.colorScheme.onSurface),
          title: Text(
            "Selecciona tu planta",
            style: darkTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTheme.colorScheme.onSurface,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: darkTheme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: "Buscar planta...",
                  hintStyle: TextStyle(color: darkTheme.colorScheme.onSurface.withAlpha(140)),
                  prefixIcon: ScaleTransition(
                    scale: _animation,
                    child: Icon(Icons.search, color: darkTheme.colorScheme.onSurface),
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _filteredPlants.isEmpty
                  ? Center(
                      child: Text(
                        "No hay resultados.",
                        style: TextStyle(color: darkTheme.colorScheme.onSurface.withAlpha(140)),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
=======
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Selecciona tu planta",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Buscar planta...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _filteredPlants.isEmpty
                    ? const Center(
                      child: Text(
                        "No hay resultados.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
                      itemCount: _filteredPlants.length,
                      itemBuilder: (context, index) {
                        final plant = _filteredPlants[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConnectGardenPage(plant: plant),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
                              boxShadow: const [
=======
                              boxShadow: [
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      plant.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
<<<<<<< HEAD
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plant.plant,
                                        style: TextStyle(
                                          color: darkTheme.colorScheme.onSurface,
=======
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plant.plant,
                                        style: const TextStyle(
                                          color: Colors.white,
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        plant.scientificName,
<<<<<<< HEAD
                                        style: TextStyle(
                                          color: darkTheme.colorScheme.onSurface.withAlpha(140),
=======
                                        style: const TextStyle(
                                          color: Colors.white70,
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
<<<<<<< HEAD
            ),
          ],
        ),
=======
          ),
        ],
>>>>>>> f0b092e414be4d459546ac653a1d76483cea15a8
      ),
    );
  }
}
