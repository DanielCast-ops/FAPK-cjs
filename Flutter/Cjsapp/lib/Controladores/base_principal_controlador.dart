import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseController {
  static const _databaseName = "cjs.db";
  static const _databaseVersion = 1;

  static Future<Database> _openDB() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cargos (
        id_cargo INTEGER PRIMARY KEY AUTOINCREMENT,
        cargo VARCHAR(20) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE clientes (
        id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre VARCHAR(50) NOT NULL,
        telefono VARCHAR(15) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE proveedores (
        id_proveedor INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre VARCHAR(50) NOT NULL,
        telefono VARCHAR(15) NOT NULL,
        tipo_de_productos VARCHAR(100)
      )
    ''');

    await db.execute('''
      CREATE TABLE empleados (
        id_personal INTEGER PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL,
        id_cargo INTEGER NOT NULL,
        telefono VARCHAR(15) NOT NULL,
        FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo)
      )
    ''');

    await db.execute('''
      CREATE TABLE articulos (
        id_articulo INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre VARCHAR(50) NOT NULL,
        especificacion VARCHAR(200),
        id_proveedor INTEGER NOT NULL,
        FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
      )
    ''');

    await db.execute('''
      CREATE TABLE inventario (
        id_transaccion INTEGER PRIMARY KEY AUTOINCREMENT,
        id_articulo INTEGER NOT NULL,
        id_personal INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        fecha DATE NOT NULL,
        notas VARCHAR(200),
        FOREIGN KEY (id_articulo) REFERENCES articulos(id_articulo),
        FOREIGN KEY (id_personal) REFERENCES empleados(id_personal)
      )
    ''');

    await db.execute('''
      CREATE TABLE estado_servicio (
        id_estado INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion VARCHAR(50) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE servicios (
        id_servicio INTEGER PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL,
        fecha DATE NOT NULL,
        telefono_extra VARCHAR(45),
        Detalles VARCHAR(100),
        estado_id INTEGER NOT NULL,
        cliente_id INTEGER NOT NULL,
        personal_id INTEGER NOT NULL,
        FOREIGN KEY (estado_id) REFERENCES estado_servicio(id_estado),
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente),
        FOREIGN KEY (personal_id) REFERENCES empleados(id_personal)
      )
    ''');
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // para agregar upgrades
  }
  
  // Cargo funciones
  static Future<int> crearCargo(String cargo) async {
    final db = await _openDB();
    return await db.insert('cargos', {'cargo': cargo},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> obtenerCargo(int idCargo) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'cargos',
      where: 'id_cargo = ?',
      whereArgs: [idCargo],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosCargos() async {
    final db = await _openDB();
    return await db.query('cargos');
  }

  static Future<int> actualizarCargo(int idCargo, String nuevoCargo) async {
    final db = await _openDB();
    return await db.update(
      'cargos',
      {'cargo': nuevoCargo},
      where: 'id_cargo = ?',
      whereArgs: [idCargo],
    );
  }

  static Future<int> eliminarCargo(int idCargo) async {
    final db = await _openDB();
    return await db.delete(
      'cargos',
      where: 'id_cargo = ?',
      whereArgs: [idCargo],
    );
  }

  // Cliente funciones
  static Future<int> crearCliente(String nombre, String telefono) async {
    final db = await _openDB();
    return await db.insert('clientes', {'nombre': nombre, 'telefono': telefono},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> obtenerCliente(int idCliente) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'clientes',
      where: 'id_cliente = ?',
      whereArgs: [idCliente],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosClientes() async {
    final db = await _openDB();
    return await db.query('clientes');
  }

  static Future<int> actualizarCliente(int idCliente, String nuevoNombre, String nuevoTelefono) async {
    final db = await _openDB();
    return await db.update(
      'clientes',
      {'nombre': nuevoNombre, 'telefono': nuevoTelefono},
      where: 'id_cliente = ?',
      whereArgs: [idCliente],
    );
  }

  static Future<int> eliminarCliente(int idCliente) async {
    final db = await _openDB();
    return await db.delete(
      'clientes',
      where: 'id_cliente = ?',
      whereArgs: [idCliente],
    );
  }

  // Proveedor funciones
  static Future<int> crearProveedor(String nombre, String telefono, String tipoDeProductos) async {
    final db = await _openDB();
    return await db.insert(
      'proveedores',
      {'nombre': nombre, 'telefono': telefono, 'tipo_de_productos': tipoDeProductos},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<Map<String, dynamic>?> obtenerProveedor(int idProveedor) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'proveedores',
      where: 'id_proveedor = ?',
      whereArgs: [idProveedor],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosProveedores() async {
    final db = await _openDB();
    return await db.query('proveedores');
  }

  static Future<int> actualizarProveedor(int idProveedor, String nuevoNombre, String nuevoTelefono, String nuevoTipoDeProductos) async {
    final db = await _openDB();
    return await db.update(
      'proveedores',
      {'nombre': nuevoNombre, 'telefono': nuevoTelefono, 'tipo_de_productos': nuevoTipoDeProductos},
      where: 'id_proveedor = ?',
      whereArgs: [idProveedor],
    );
  }

  static Future<int> eliminarProveedor(int idProveedor) async {
    final db = await _openDB();
    return await db.delete(
      'proveedores',
      where: 'id_proveedor = ?',
      whereArgs: [idProveedor],
    );
  }

  // Empleado funciones
  static Future<int> crearEmpleado(String nombre, int idCargo, String telefono) async {
    final db = await _openDB();
    return await db.insert(
      'empleados',
      {'nombre': nombre, 'id_cargo': idCargo, 'telefono': telefono},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<Map<String, dynamic>?> obtenerEmpleado(int idPersonal) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'empleados',
      where: 'id_personal = ?',
      whereArgs: [idPersonal],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosEmpleados() async {
    final db = await _openDB();
    return await db.query('empleados');
  }

  static Future<int> actualizarEmpleado(int idPersonal, String nuevoNombre, int nuevoIdCargo, String nuevoTelefono) async {
    final db = await _openDB();
    return await db.update(
      'empleados',
      {'nombre': nuevoNombre, 'id_cargo': nuevoIdCargo, 'telefono': nuevoTelefono},
      where: 'id_personal = ?',
      whereArgs: [idPersonal],
    );
  }

  static Future<int> eliminarEmpleado(int idPersonal) async {
    final db = await _openDB();
    return await db.delete(
      'empleados',
      where: 'id_personal = ?',
      whereArgs: [idPersonal],
    );
  }

  // Articulo funciones
  static Future<int> crearArticulo(String nombre, String especificacion, int idProveedor) async {
    final db = await _openDB();
    return await db.insert(
      'articulos',
      {'nombre': nombre, 'especificacion': especificacion, 'id_proveedor': idProveedor},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<Map<String, dynamic>?> obtenerArticulo(int idArticulo) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'articulos',
      where: 'id_articulo = ?',
      whereArgs: [idArticulo],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<Map<String, dynamic>?> obtenerArticuloPorNombre(String nombreArticulo) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'articulos',
      where: 'nombre = ?',
      whereArgs: [nombreArticulo],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosArticulos() async {
    final db = await _openDB();
    return await db.query('articulos');
  }

  static Future<int> actualizarArticulo(int idArticulo, String nuevoNombre, String nuevaEspecificacion, int nuevoIdProveedor) async {
    final db = await _openDB();
    return await db.update(
      'articulos',
      {'nombre': nuevoNombre, 'especificacion': nuevaEspecificacion, 'id_proveedor': nuevoIdProveedor},
      where: 'id_articulo = ?',
      whereArgs: [idArticulo],
    );
  }

  static Future<int> eliminarArticulo(int idArticulo) async {
    final db = await _openDB();
    return await db.delete(
      'articulos',
      where: 'id_articulo = ?',
      whereArgs: [idArticulo],
    );
  }

  // Inventario funciones
  static Future<int> crearTransaccion(int idArticulo, int idPersonal, int cantidad, String fecha, String? notas) async {
    final db = await _openDB();
    return await db.insert(
      'inventario',
      {'id_articulo': idArticulo, 'id_personal': idPersonal, 'cantidad': cantidad, 'fecha': fecha, 'notas': notas},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<Map<String, dynamic>?> obtenerTransaccion(int idTransaccion) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'inventario',
      where: 'id_transaccion = ?',
      whereArgs: [idTransaccion],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<int> actualizarTransaccion(int idTransaccion, int nuevoIdArticulo, int nuevoIdPersonal, int nuevaCantidad, String nuevaFecha, String? nuevasNotas) async {
    final db = await _openDB();
    return await db.update(
      'inventario',
      {'id_articulo': nuevoIdArticulo, 'id_personal': nuevoIdPersonal, 'cantidad': nuevaCantidad, 'fecha': nuevaFecha, 'notas': nuevasNotas},
      where: 'id_transaccion = ?',
      whereArgs: [idTransaccion],
    );
  }

  static Future<int> eliminarTransaccion(int idTransaccion) async {
    final db = await _openDB();
    return await db.delete(
      'inventario',
      where: 'id_transaccion = ?',
      whereArgs: [idTransaccion],
    );
  }

  static Future<int> obtenerCantidadArticulo(int idArticulo) async {
    final db = await _openDB();
    var result = await db.rawQuery('SELECT SUM(cantidad) as total FROM inventario WHERE id_articulo = ?', [idArticulo]);
    return result.first['total'] as int? ?? 0;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosMovimientos() async {
    final db = await _openDB();
    return await db.query('inventario', orderBy: 'id_transaccion DESC');
  }

  // Servicio funciones
  
  static Future<int> crearServicio(String nombre, String fecha, String? telefonoExtra, String? detalles, int estadoId, int clienteId, int personalId) async {
    final db = await _openDB();
    return await db.insert(
      'servicios',
      {
        'nombre': nombre,
        'fecha': fecha,
        'telefono_extra': telefonoExtra,
        'Detalles': detalles,
        'estado_id': estadoId,
        'cliente_id': clienteId,
        'personal_id': personalId
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<Map<String, dynamic>?> obtenerServicio(int idServicio) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'servicios',
      where: 'id_servicio = ?',
      whereArgs: [idServicio],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<int> actualizarServicio(int idServicio, String nuevoNombre, String nuevaFecha, String? nuevoTelefonoExtra, String? nuevosDetalles, int nuevoEstadoId, int nuevoClienteId, int nuevoIdPersonal) async {
    final db = await _openDB();
    return await db.update(
      'servicios',
      {'nombre': nuevoNombre, 'fecha': nuevaFecha, 'telefono_extra': nuevoTelefonoExtra, 'Detalles': nuevosDetalles, 'estado_id': nuevoEstadoId, 'cliente_id': nuevoClienteId, 'personal_id': nuevoIdPersonal},
      where: 'id_servicio = ?',
      whereArgs: [idServicio],
    );
  }

  static Future<int> eliminarServicio(int idServicio) async {
    final db = await _openDB();
    return await db.delete(
      'servicios',
      where: 'id_servicio = ?',
      whereArgs: [idServicio],
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosServicios() async {
    final db = await _openDB();
    return await db.query('servicios');
  }

  // EstadoServicio funciones
  static Future<int> crearEstadoServicio(String descripcion) async {
    final db = await _openDB();
    return await db.insert('estado_servicio', {'descripcion': descripcion},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> obtenerEstadoServicio(int idEstado) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'estado_servicio',
      where: 'id_estado = ?',
      whereArgs: [idEstado],
    );
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosLosEstados() async {
    final db = await _openDB();
    return await db.query('estado_servicio');
  }

  static Future<int> actualizarEstadoServicio(int idEstado, String nuevaDescripcion) async {
  final db = await _openDB();
  return await db.update(
    'estado_servicio',
    {'descripcion': nuevaDescripcion},
    where: 'id_estado = ?',
    whereArgs: [idEstado],
  );
}

  static Future<int> eliminarEstadoServicio(int idEstado) async {
    final db = await _openDB();
    return await db.delete(
      'estado_servicio',
      where: 'id_estado = ?',
      whereArgs: [idEstado],
    );
  }

  static Future<void> cerrarConexion() async {
    final db = await _openDB();
    await db.close();
  }
}
