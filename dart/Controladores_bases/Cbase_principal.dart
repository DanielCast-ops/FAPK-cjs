import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseCreator {
  static Future<void> crearTablas(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cargos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cargo TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes (
          id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          telefono TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS proveedores (
          id_proveedor INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          telefono TEXT NOT NULL,
          tipo_de_productos TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS empleados (
          id_personal INTEGER PRIMARY KEY,
          nombre TEXT NOT NULL,
          id_cargo INTEGER NOT NULL,
          telefono TEXT NOT NULL,
          FOREIGN KEY (id_cargo) REFERENCES cargos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS articulos (
          id_articulo INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          especificacion TEXT,
          id_proveedor INTEGER NOT NULL,
          FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS inventario (
          id_transaccion INTEGER PRIMARY KEY AUTOINCREMENT,
          id_articulo INTEGER NOT NULL,
          id_personal INTEGER NOT NULL,
          cantidad INTEGER NOT NULL,
          fecha TEXT NOT NULL,
          notas TEXT,
          FOREIGN KEY (id_articulo) REFERENCES articulos(id_articulo),
          FOREIGN KEY (id_personal) REFERENCES empleados(id_personal)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS estado_servicio (
          id_estado INTEGER PRIMARY KEY AUTOINCREMENT,
          descripcion TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS servicios (
          id_servicio INTEGER PRIMARY KEY,
          nombre TEXT NOT NULL,
          fecha TEXT NOT NULL,
          telefono_extra TEXT,
          detalles TEXT,
          estado_id INTEGER NOT NULL,
          cliente_id INTEGER NOT NULL,
          personal_id INTEGER NOT NULL,
          FOREIGN KEY (estado_id) REFERENCES estado_servicio(id_estado),
          FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente),
          FOREIGN KEY (personal_id) REFERENCES empleados(id_personal)
      )
    ''');
  }

  static Future<Database> openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'cjs.db'),
      version: 1,
      onCreate: (db, version) async {
        await crearTablas(db);
      },
    );
  }
}

