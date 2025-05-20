import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class Product {
  final String name;
  final String image;
  final String price;

  Product({required this.name, required this.image, required this.price});
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Product>> categories = {
    'Fertilizantes': [
      Product(name: 'Fertilizante Orgánico', image: 'assets/images/fertilizante_organico.jpg', price: '1kg - \$10'),
      Product(name: 'Fertilizante Líquido', image: 'assets/images/fertilizante_liquido.jpg', price: '500 ml - \$8'),
      Product(name: 'Fertilizante para Flores', image: 'assets/images/fertilizante_flores.jpg', price: '1kg - \$12'),
      Product(name: 'Fertilizante Universal', image: 'assets/images/fertilizante_universal.jpg', price: '1kg - \$9'),
      Product(name: 'Fertilizante para Hortalizas', image: 'assets/images/fertilizante_hortalizas.jpg', price: '1kg - \$11'),
      Product(name: 'Fertilizante para Césped', image: 'assets/images/fertilizante_cesped.jpg', price: '1kg - \$10'),
    ],
    'Abonos': [
      Product(name: 'Abono de Lombriz', image: 'assets/images/abono_lombriz.jpg', price: '\$12.00'),
      Product(name: 'Compost Vegetal', image: 'assets/images/compost_vegetal.jpg', price: '\$15.00'),
      Product(name: 'Humus de Estiércol', image: 'assets/images/humus.jpg', price: '\$10.00'),
      Product(name: 'Guano de Murciélago', image: 'assets/images/guano.jpg', price: '\$20.00'),
      Product(name: 'Abono Líquido', image: 'assets/images/abono_liquido.jpg', price: '\$8.00'),
      Product(name: 'Abono Granulado', image: 'assets/images/abono_granulado.jpg', price: '\$11.00'),
    ],
    'Plantas': [
      Product(name: 'Planta de Tomate', image: 'assets/images/planta_tomate.jpg', price: '\$3.50'),
      Product(name: 'Planta de Pepino', image: 'assets/images/planta_pepino.jpg', price: '\$3.00'),
      Product(name: 'Planta de Pimiento', image: 'assets/images/planta_pimiento.jpg', price: '\$2.75'),
      Product(name: 'Planta de Lechuga', image: 'assets/images/planta_lechuga.jpg', price: '\$2.25'),
      Product(name: 'Planta de Zanahoria', image: 'assets/images/planta_zanahoria.jpg', price: '\$2.50'),
      Product(name: 'Planta de Fresa', image: 'assets/images/planta_fresa.jpg', price: '\$4.00'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.price,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark();

    return Theme(
      data: darkTheme,
      child: Scaffold(
        backgroundColor: darkTheme.colorScheme.surface,
        appBar: AppBar(
          title: const Text('Tienda'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: categories.keys.map((cat) {
              IconData icon;
              switch (cat) {
                case 'Fertilizantes':
                  icon = Icons.local_florist;
                  break;
                case 'Abonos':
                  icon = Icons.recycling;
                  break;
                case 'Plantas':
                default:
                  icon = Icons.spa;
                  break;
              }
              return Tab(
                icon: Icon(icon),
                text: cat,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: categories.entries.map((entry) {
            final products = entry.value;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (_, index) => _buildProductCard(products[index]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
