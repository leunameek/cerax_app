import 'package:flutter/material.dart';
import 'package:cerax_app_v1/presentation/pages/interactive_welcome_page.dart';
import 'package:cerax_app_v1/presentation/pages/my_plants_page.dart';
import 'package:cerax_app_v1/presentation/pages/store_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    3,
    (_) => GlobalKey<NavigatorState>(),
  );

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(int index, Widget rootPage) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (_) => rootPage,
            settings: settings,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOffstageNavigator(0, const InteractiveWelcomePage()),
          _buildOffstageNavigator(1, const MyPlantsPage()),
          _buildOffstageNavigator(2, const StorePage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xff607afb),
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_vintage_outlined),
            label: 'Mis Plantas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Tienda'),
        ],
      ),
    );
  }
}
