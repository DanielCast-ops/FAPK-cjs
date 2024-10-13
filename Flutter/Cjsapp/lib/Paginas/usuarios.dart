import 'package:flutter/material.dart';
import 'package:Cjsapp/Controladores/base_usuario_controlador.dart';
import 'package:Cjsapp/Modelos/usuario.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final BaseUsuarioControlador db = BaseUsuarioControlador();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = "";
  List<User> users = [];
  User? currentUser;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    List<User> loadedUsers = await db.listarUsuarios();
    setState(() {
      users = loadedUsers;
    });
  }

  void addUser() async {
    String username = usernameController.text;
    String password = passwordController.text;
    User newUser = User(username: username, password: password);
    bool success = await db.registrarUsuario(newUser);
    setState(() {
      if (success) {
        message = "Usuario registrado exitosamente.";
        loadUsers();
      } else {
        message = "Error: El nombre de usuario ya existe.";
      }
      usernameController.clear();
      passwordController.clear();
    });
  }

  void editUser(User user) {
    setState(() {
      currentUser = user;
      usernameController.text = user.username;
      passwordController.clear();
    });
  }

  void updateUser() async {
    if (currentUser != null) {
      String newPassword = passwordController.text;
      bool success = await db.actualizarUsuario(currentUser!.username, newPassword);
      setState(() {
        if (success) {
          message = "Usuario actualizado exitosamente.";
          loadUsers();
        } else {
          message = "Error al actualizar el usuario.";
        }
        usernameController.clear();
        passwordController.clear();
        currentUser = null;
      });
    }
  }

  void deleteUser(String username) async {
    bool success = await db.eliminarUsuario(username);
    setState(() {
      if (success) {
        message = "Usuario eliminado exitosamente.";
        loadUsers();
      } else {
        message = "Error al eliminar el usuario.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // El resto del método build permanece sin cambios
    // ...
  }
}