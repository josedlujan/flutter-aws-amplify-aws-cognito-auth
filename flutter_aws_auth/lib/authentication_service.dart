import 'package:amplify_flutter/amplify_flutter.dart';

class AuthenticationService {
  //Future<void> signUp(String email, String password) async {
  Future<String> signUp(String email, String password) async {
    try {
      SignUpResult result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: {
          // 'email': email,
          AuthUserAttributeKey.email: email,
        }),
      );
      if (result.nextStep.signUpStep == "confirmSignUp") {
        print("Usuario necesita confirmar su cuenta.");
        return "confirmSignUp"; // ✅ Devuelve este string si se requiere confirmación
      }
      print("Usuario registrado correctamente.");
      return "signedUp"; // ✅ Usuario registrado correctamente
    } catch (e) {
      print("Error en el registro: $e");
      return "error"; // ✅ Devuelve "error" en caso de excepción
    }

    //   print("Usuario registrado correctamente.");
    // } catch (e) {
    //    print("Error en el registro: $e");
    //  }
  }

  /// Confirmar el registro del usuario con el código de verificación enviado al email
  Future<void> confirmSignUp(String email, String confirmationCode) async {
    try {
      SignUpResult result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      print("Usuario confirmado correctamente.");
    } catch (e) {
      print("Error al confirmar usuario: $e");
    }
  }

  // Future<void> signIn(String username, String password) async {
  Future<String> signIn(String username, String password) async {
    print('Iniciando sesión');
    print(username + password);
    try {
      SignInResult result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      /*  if (result.isSignedIn) {
        print('Usuario autenticado correctamente');
      }
      print(result);
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      // print(result);
    }
    //print(result);*/
      if (result.isSignedIn) {
        print("Inicio de sesión exitoso.");
        return "signedIn"; // ✅ Esto activa la redirección a HomeScreen
      } else if (result.nextStep.signInStep == "confirmSignUp") {
        print("Usuario necesita confirmar su cuenta.");
        return "confirmSignUp";
      } else {
        print("Inicio de sesión incompleto.");
        return "incomplete";
      }
    } catch (e) {
      print("Error en el inicio de sesión: $e");
      return "error";
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('Sesión cerrada');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
