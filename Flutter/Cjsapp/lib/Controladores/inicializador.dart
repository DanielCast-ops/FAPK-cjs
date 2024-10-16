import 'package:cjsapp/Controladores/base_usuario_controlador.dart';
import 'package:cjsapp/Modelos/usuario.dart';
import 'package:cjsapp/Controladores/base_principal_controlador.dart';
import 'package:cjsapp/Modelos/principal.dart';
import 'dart:developer';

class Inicializacion {
  static final BaseUsuarioControlador _userDb = BaseUsuarioControlador();

  static Future<void> inicializar() async {
    await _crearUsuarioAdmin();
    await _crearCargoPorDefecto();
    await _crearClientePorDefecto();
    await _crearEmpleadoPorDefecto();
    await _crearEstadosServicioPorDefecto();
    await _crearProveedorPorDefecto();
  }

  static Future<void> _crearUsuarioAdmin() async {
    const String adminUsername = 'admin';
    const String adminPassword = 'admin';

    User? existingAdmin = await _userDb.consultarUsuario(adminUsername);
    if (existingAdmin == null) {
      User newAdmin = User(username: adminUsername, password: adminPassword);
      bool success = await _userDb.registrarUsuario(newAdmin);
      if (success) {
        log('Usuario admin creado con éxito');
      } else {
        log('No se pudo crear el usuario admin');
      }
    } else {
      log('El usuario admin ya existe');
    }
  }

  static Future<void> _crearCargoPorDefecto() async {
    Cargo? existingCargo = await DatabaseController.obtenerCargo(1);
    if (existingCargo == null) {
      Cargo newCargo = Cargo(cargo: 'user');
      int id = await DatabaseController.crearCargo(newCargo);
      log('Registro creado en "cargo" con id: $id');
    }
  }

  static Future<void> _crearClientePorDefecto() async {
    Cliente? existingCliente = await DatabaseController.obtenerCliente(1);
    if (existingCliente == null) {
      Cliente newCliente = Cliente(nombre: 'cliente', telefono: 'ninguno');
      int id = await DatabaseController.crearCliente(newCliente);
      log('Registro creado en "cliente" con id: $id');
    }
  }

  static Future<void> _crearEmpleadoPorDefecto() async {
    Empleado? existingEmpleado = await DatabaseController.obtenerEmpleado(1);
    if (existingEmpleado == null) {
      Empleado newEmpleado = Empleado(nombre: 'empleado', idCargo: 1, telefono: 'ninguno');
      int id = await DatabaseController.crearEmpleado(newEmpleado);
      log('Registro creado en "empleados" con id: $id');
    }
  }

  static Future<void> _crearEstadosServicioPorDefecto() async {
    List<String> estadosDefault = ['recibido', 'en proceso', 'terminado'];
    for (int i = 0; i < estadosDefault.length; i++) {
      EstadoServicio? existingEstado = await DatabaseController.obtenerEstadoServicio(i + 1);
      if (existingEstado == null) {
        EstadoServicio newEstado = EstadoServicio(descripcion: estadosDefault[i]);
        int id = await DatabaseController.crearEstadoServicio(newEstado);
        log('Registro creado en "estado_servicio" con id: $id');
      }
    }
  }

  static Future<void> _crearProveedorPorDefecto() async {
    Proveedor? existingProveedor = await DatabaseController.obtenerProveedor(1);
    if (existingProveedor == null) {
      Proveedor newProveedor = Proveedor(
        nombre: 'proveedor',
        telefono: 'ninguno',
        tipoDeProductos: 'ninguno'
      );
      int id = await DatabaseController.crearProveedor(newProveedor);
      log('Registro creado en "proveedores" con id: $id');
    }
  }
}