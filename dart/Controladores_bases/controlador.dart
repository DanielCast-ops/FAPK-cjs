import 'package:sqflite/sqflite.dart';
import 'database_creator.dart';

class DatabaseHelper {
   // para la tabla 'cargos'
  static Future<int> crearCargo(String cargo) async {
    final db = await _openDB();
    return await db.insert('cargos', {'cargo': cargo},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerCargos() async {
    final db = await _openDB();
    return db.query('cargos');
  }

  static Future<int> actualizarCargo(int id, String nuevoCargo) async {
    final db = await _openDB();
    return await db.update(
      'cargos',
      {'cargo': nuevoCargo},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminarCargo(int id) async {
    final db = await _openDB();
    return await db.delete(
      'cargos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // pendiente crear todos los de obtener todos los * 
  // para la tabla 'clientes'
  static Future<int> crearCliente(String nombre, String telefono) async {
    final db = await _openDB();
    return await db.insert('clientes', {'nombre': nombre, 'telefono': telefono},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerClientes() async {
    final db = await _openDB();
    return db.query('clientes');
  }

  // para la tabla 'proveedores'
  static Future<int> crearProveedor(
      String nombre, String telefono, String tipoDeProductos) async {
    final db = await _openDB();
    return await db.insert(
        'proveedores',
        {
          'nombre': nombre,
          'telefono': telefono,
          'tipo_de_productos': tipoDeProductos
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerProveedores() async {
    final db = await _openDB();
    return db.query('proveedores');
  }

  // para la tabla 'empleados'
  static Future<int> crearEmpleado(
      String nombre, int idCargo, String telefono) async {
    final db = await _openDB();
    return await db.insert(
        'empleados',
        {
          'nombre': nombre,
          'id_cargo': idCargo,
          'telefono': telefono,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerEmpleados() async {
    final db = await _openDB();
    return db.query('empleados');
  }

  // para la tabla 'articulos'
  static Future<int> crearArticulo(
      String nombre, String especificacion, int idProveedor) async {
    final db = await _openDB();
    return await db.insert(
        'articulos',
        {
          'nombre': nombre,
          'especificacion': especificacion,
          'id_proveedor': idProveedor
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerArticulos() async {
    final db = await _openDB();
    return db.query('articulos');
  }

  // para la tabla 'inventario'
  static Future<int> crearTransaccion(int idArticulo, int idPersonal,
      int cantidad, String fecha, String notas) async {
    final db = await _openDB();
    return await db.insert(
        'inventario',
        {
          'id_articulo': idArticulo,
          'id_personal': idPersonal,
          'cantidad': cantidad,
          'fecha': fecha,
          'notas': notas
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerInventario() async {
    final db = await _openDB();
    return db.query('inventario');
  }

  //  para la tabla 'servicios'
  static Future<int> crearServicio(
      String nombre,
      String fecha,
      String telefonoExtra,
      String detalles,
      int estadoId,
      int clienteId,
      int personalId) async {
    final db = await _openDB();
    return await db.insert(
        'servicios',
        {
          'nombre': nombre,
          'fecha': fecha,
          'telefono_extra': telefonoExtra,
          'detalles': detalles,
          'estado_id': estadoId,
          'cliente_id': clienteId,
          'personal_id': personalId
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerServicios() async {
    final db = await _openDB();
    return db.query('servicios');
  }

  // Métodos para la tabla 'estado_servicio'
  static Future<int> crearEstadoServicio(String descripcion) async {
    final db = await _openDB();
    return await db.insert('estado_servicio', {'descripcion': descripcion},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadosServicio() async {
    final db = await _openDB();
    return db.query('estado_servicio');
  }
}
}

