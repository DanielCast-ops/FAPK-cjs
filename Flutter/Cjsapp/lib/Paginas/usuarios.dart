import 'package:flutter/material.dart';
import 'package:Cjsapp/Controladores/base_usuario_controlador.dart';
import 'package:Cjsapp/Modelos/usuario.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administración de Usuarios"),
        backgroundColor: const Color(0xFF316938),
      ),
      body: Container(
        color: const Color(0xFFF0F0F0),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User user = users[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ID: ${user.id}", style: const TextStyle (color: Color(0xFF316938))),
                          Text("Nombre: ${user.username}", style: const TextStyle(color: Color(0xFF316938))),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xFF316938)),
                            onPressed: () => editUser(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Color(0xFF316938)),
                            onPressed: () => deleteUser(user.username),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(color: Color(0xFF316938)),
              const Text(
                "Agregar/Editar Usuario:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF316938)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de usuario",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF316938)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF316938)),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: currentUser == null ? addUser : updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF316938),
                  foregroundColor: Colors.white,
                ),
                child: Text(currentUser == null ? "Agregar usuario" : "Actualizar usuario"),
              ),
              const SizedBox(height: 10),
              Text(message, style: const TextStyle(color: Color(0xFF316938))),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color(0xFF316938),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Regresar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
