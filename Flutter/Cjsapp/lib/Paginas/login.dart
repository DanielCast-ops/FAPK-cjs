import 'package:flutter/material.dart';
import 'package:cjsapp/Controladores/base_usuario_controlador.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/Imagenes/icon.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Iniciar Sesión",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF316938),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de usuario",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF316938)),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration (
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF316938)),
                  ),
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loginLogic,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF316938),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Iniciar Sesión"),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(color: messageColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}