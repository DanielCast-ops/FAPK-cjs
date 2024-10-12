import 'package:flutter/material.dart';
import 'package:your_project_name/controllers/user_database_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserDatabaseController db = UserDatabaseController();
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
        // a la página principal
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
      backgroundColor: Color(0xFFF0F0F0),
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
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
                'assets/icon.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                "Iniciar Sesión",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF316938),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF316938)),
                  ),
                ),
                autofocus: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
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
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Iniciar Sesión"),
                onPressed: loginLogic,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF316938),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
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
