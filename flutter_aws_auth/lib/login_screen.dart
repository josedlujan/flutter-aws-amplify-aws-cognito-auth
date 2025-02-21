import 'package:flutter/material.dart';
import 'package:flutter_aws_auth/home_screen.dart';
import 'authentication_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameSignupController = TextEditingController();
  final _passwordSignupController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  final _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameSignupController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordSignupController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await _authService.signUp(
                  _usernameSignupController.text.trim(),
                  _passwordSignupController.text.trim(),
                );
                if (result == "confirmSignUp") {
                  _showConfirmationDialog();
                }
              },
              child: const Text("Registrarse"),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var result = await _authService.signIn(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                );
                if (result == "signedIn") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                } else if (result == "confirmSignUp") {
                  _showConfirmationDialog();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: No se pudo iniciar sesión")),
                  );
                }
              },
              child: const Text("Iniciar Sesión"),
            ),
            ElevatedButton(
              onPressed: () {
                _authService.signOut();
              },
              child: const Text("Sign out"),
            )
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmar Cuenta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _confirmationCodeController,
                decoration:
                    InputDecoration(labelText: "Código de Confirmación"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _authService.confirmSignUp(
                  _usernameSignupController.text.trim(),
                  _confirmationCodeController.text.trim(),
                );
                Navigator.pop(context);
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }
}
