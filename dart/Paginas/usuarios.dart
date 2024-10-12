import 'package:flutter/material.dart';
import 'package:your_project_name/controllers/user_database_controller.dart';
import 'package:your_project_name/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserDatabaseController db = UserDatabaseController();
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
    List<Map<String, dynamic>> usersData = await db.listarUsuarios();
    setState(() {
      users = usersData.map((userData) => User.fromMap(userData)).toList();
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
        title: Text("Administración de Usuarios"),
        backgroundColor: Color(0xFF316938),
      ),
      body: Container(
        color: Color(0xFFF0F0F0),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User user = users[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ID: ${user.id}", style: TextStyle(color: Color(0xFF316938))),
                          Text("Nombre: ${user.username}", style: TextStyle(color: Color(0xFF316938))),
                          IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFF316938)),
                            onPressed: () => editUser(user),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Color(0xFF316938)),
                            onPressed: () => deleteUser(user.username),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(color: Color(0xFF316938)),
              Text(
                "Agregar/Editar Usuario:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF316938)),
              ),
              SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF316938)),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text(currentUser == null ? "Agregar usuario" : "Actualizar usuario"),
                onPressed: currentUser == null ? addUser : updateUser,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF316938),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(message, style: TextStyle(color: Color(0xFF316938))),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("Regresar"),
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF316938),
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
