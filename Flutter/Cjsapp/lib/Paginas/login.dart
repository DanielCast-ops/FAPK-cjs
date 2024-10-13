import 'package:flutter/material.dart';
import 'package:Cjsapp/Controladores/base_usuario_controlador.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final BaseUsuarioControlador db = BaseUsuarioControlador();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = "";
  Color messageColor = Colors.green;

  void loginLogic() async {
    String username = usernameController.text;
    String password = passwordController.text;

    bool isValid = await db.verificarLogin(username, password);
    setState(() {
      if (isValid) {
        message = "Login exitoso!";
        messageColor = Colors.green;
        // Navegar a la página principal
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        message = "Nombre de usuario o contraseña incorrectos.";
        messageColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // El resto del método build permanece sin cambios
    // ...
  }
}