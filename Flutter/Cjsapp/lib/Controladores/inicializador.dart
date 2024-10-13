import 'package:Cjsapp/Controladores/base_usuario_controlador.dart';
import 'package:Cjsapp/Modelos/usuario.dart';
import 'dart:developer';

class Inicializacion {
  static final BaseUsuarioControlador _db = BaseUsuarioControlador();

  static Future<void> inicializar() async {
    await _crearUsuarioAdmin();
    // Aquí puedes añadir más funciones de inicialización si es necesario
  }

  static Future<void> _crearUsuarioAdmin() async {
    const String adminUsername = 'admin';
    const String adminPassword = 'admin';

    User? existingAdmin = await _db.consultarUsuario(adminUsername);
    if (existingAdmin == null) {
      User newAdmin = User(username: adminUsername, password: adminPassword);
      bool success = await _db.registrarUsuario(newAdmin);
      if (success) {
        log('Usuario admin creado con éxito');
      } else {
        log('No se pudo crear el usuario admin');
      }
    } else {
      log('El usuario admin ya existe');
    }
  }
}