import 'package:flutter/material.dart';
import 'authentication_service.dart';

class HomeScreen extends StatelessWidget {
  final _authService = AuthenticationService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authService.signOut();
            Navigator.pop(context);
          },
          child: const Text("Cerrar Sesión"),
        ),
      ),
    );
  }
}
