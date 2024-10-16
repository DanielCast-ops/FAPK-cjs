import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cjsapp/Modelos/principal.dart';

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
  static Future<int> crearCargo(Cargo cargo) async {
    final db = await _openDB();
    return await db.insert('cargos', cargo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Cargo?> obtenerCargo(int idCargo) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'cargos',
      where: 'id_cargo = ?',
      whereArgs: [idCargo],
    );
    return results.isNotEmpty ? Cargo.fromMap(results.first) : null;
  }

  static Future<List<Cargo>> obtenerTodosLosCargos() async {
    final db = await _openDB();
    final results = await db.query('cargos');
    return results.map((map) => Cargo.fromMap(map)).toList();
  }

  static Future<int> actualizarCargo(Cargo cargo) async {
    final db = await _openDB();
    return await db.update(
      'cargos',
      cargo.toMap(),
      where: 'id_cargo = ?',
      whereArgs: [cargo.idCargo],
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
  static Future<int> crearCliente(Cliente cliente) async {
    final db = await _openDB();
    return await db.insert('clientes', cliente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Cliente?> obtenerCliente(int idCliente) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'clientes',
      where: 'id_cliente = ?',
      whereArgs: [idCliente],
    );
    return results.isNotEmpty ? Cliente.fromMap(results.first) : null;
  }

  static Future<List<Cliente>> obtenerTodosLosClientes() async {
    final db = await _openDB();
    final results = await db.query('clientes');
    return results.map((map) => Cliente.fromMap(map)).toList();
  }

  static Future<int> actualizarCliente(Cliente cliente) async {
    final db = await _openDB();
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id_cliente = ?',
      whereArgs: [cliente.idCliente],
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
  static Future<int> crearProveedor(Proveedor proveedor) async {
    final db = await _openDB();
    return await db.insert('proveedores', proveedor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Proveedor?> obtenerProveedor(int idProveedor) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'proveedores',
      where: 'id_proveedor = ?',
      whereArgs: [idProveedor],
    );
    return results.isNotEmpty ? Proveedor.fromMap(results.first) : null;
  }

  static Future<List<Proveedor>> obtenerTodosLosProveedores() async {
    final db = await _openDB();
    final results = await db.query('proveedores');
    return results.map((map) => Proveedor.fromMap(map)).toList();
  }

  static Future<int> actualizarProveedor(Proveedor proveedor) async {
    final db = await _openDB();
    return await db.update(
      'proveedores',
      proveedor.toMap(),
      where: 'id_proveedor = ?',
      whereArgs: [proveedor.idProveedor],
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
  static Future<int> crearEmpleado(Empleado empleado) async {
    final db = await _openDB();
    return await db.insert('empleados', empleado.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Empleado?> obtenerEmpleado(int idPersonal) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'empleados',
      where: 'id_personal = ?',
      whereArgs: [idPersonal],
    );
    return results.isNotEmpty ? Empleado.fromMap(results.first) : null;
  }

  static Future<List<Empleado>> obtenerTodosLosEmpleados() async {
    final db = await _openDB();
    final results = await db.query('empleados');
    return results.map((map) => Empleado.fromMap(map)).toList();
  }

  static Future<int> actualizarEmpleado(Empleado empleado) async {
    final db = await _openDB();
    return await db.update(
      'empleados',
      empleado.toMap(),
      where: 'id_personal = ?',
      whereArgs: [empleado.idPersonal],
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
  static Future<int> crearArticulo(Articulo articulo) async {
    final db = await _openDB();
    return await db.insert('articulos', articulo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Articulo?> obtenerArticulo(int idArticulo) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'articulos',
      where: 'id_articulo = ?',
      whereArgs: [idArticulo],
    );
    return results.isNotEmpty ? Articulo.fromMap(results.first) : null;
  }

  static Future<Articulo?> obtenerArticuloPorNombre(String nombreArticulo) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'articulos',
      where: 'nombre = ?',
      whereArgs: [nombreArticulo],
    );
    return results.isNotEmpty ? Articulo.fromMap(results.first) : null;
  }

  static Future<List<Articulo>> obtenerTodosLosArticulos() async {
    final db = await _openDB();
    final results = await db.query('articulos');
    return results.map((map) => Articulo.fromMap(map)).toList();
  }

  static Future<int> actualizarArticulo(Articulo articulo) async {
    final db = await _openDB();
    return await db.update(
      'articulos',
      articulo.toMap(),
      where: 'id_articulo = ?',
      whereArgs: [articulo.idArticulo],
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
  static Future<int> crearTransaccion(Inventario inventario) async {
    final db = await _openDB();
    return await db.insert('inventario', inventario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Inventario?> obtenerTransaccion(int idTransaccion) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'inventario',
      where: 'id_transaccion = ?',
      whereArgs: [idTransaccion],
    );
    return results.isNotEmpty ? Inventario.fromMap(results.first) : null;
  }

  static Future<int> actualizarTransaccion(Inventario inventario) async {
    final db = await _openDB();
    return await db.update(
      'inventario',
      inventario.toMap(),
      where: 'id_transaccion = ?',
      whereArgs: [inventario.idTransaccion],
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

  static Future<List<Inventario>> obtenerTodosLosMovimientos() async {
    final db = await _openDB();
    final results = await db.query('inventario', orderBy: 'id_transaccion DESC');
    return results.map((map) => Inventario.fromMap(map)).toList();
  }

  // Servicio funciones
  static Future<int> crearServicio(Servicio servicio) async {
    final db = await _openDB();
    return await db.insert('servicios', servicio.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Servicio?> obtenerServicio(int idServicio) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'servicios',
      where: 'id_servicio = ?',
      whereArgs: [idServicio],
    );
    return results.isNotEmpty ? Servicio.fromMap(results.first) : null;
  }

  static Future<int> actualizarServicio(Servicio servicio) async {
    final db = await _openDB();
    return await db.update(
      'servicios',
      servicio.toMap(),
      where: 'id_servicio = ?',
      whereArgs: [servicio.idServicio],
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

  static Future<List<Servicio>> obtenerTodosLosServicios() async {
    final db = await _openDB();
    final results = await db.query('servicios');
    return results.map((map) => Servicio.fromMap(map)).toList();
  }

  // EstadoServicio funciones
  static Future<int> crearEstadoServicio(EstadoServicio estadoServicio) async {
    final db = await _openDB();
    return await db.insert('estado_servicio', estadoServicio.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<EstadoServicio?> obtenerEstadoServicio(int idEstado) async {
    final db = await _openDB();
    List<Map<String, dynamic>> results = await db.query(
      'estado_servicio',
      where: 'id_estado = ?',
      whereArgs: [idEstado],
    );
    return results.isNotEmpty ? EstadoServicio.fromMap(results.first) : null;
  }

  static Future<List<EstadoServicio>> obtenerTodosLosEstados() async {
    final db = await _openDB();
    final results = await db.query('estado_servicio');
    return results.map((map) => EstadoServicio.fromMap(map)).toList();
  }

  static Future<int> actualizarEstadoServicio(EstadoServicio estadoServicio) async {
    final db = await _openDB();
    return await db.update(
      'estado_servicio',
      estadoServicio.toMap(),
      where: 'id_estado = ?',
      whereArgs: [estadoServicio.idEstado],
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