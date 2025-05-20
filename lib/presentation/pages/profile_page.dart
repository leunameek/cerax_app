import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF111111),
      body: Center(
        child: Text(
          "Tu perfil estará aquí 👤",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
