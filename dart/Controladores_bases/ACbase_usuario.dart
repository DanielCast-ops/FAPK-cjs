import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserDatabaseController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> registrarUsuario(String username, String password) async {
    final db = await database;
    String hashedPassword = _hashPassword(password);
    try {
      await db.insert('users', {
        'username': username,
        'password': hashedPassword
      });
      return true;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return false;
      }
      rethrow;
    }
  }

  Future<bool> verificarLogin(String username, String password) async {
    final db = await database;
    String hashedPassword = _hashPassword(password);
    List<Map> result = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, hashedPassword]);
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> consultarUsuario(String username) async {
    final db = await database;
    List<Map> result = await db.query('users',
        columns: ['id', 'username'],
        where: 'username = ?',
        whereArgs: [username]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<bool> actualizarUsuario(String username, String newPassword) async {
    final db = await database;
    String hashedPassword = _hashPassword(newPassword);
    int count = await db.update('users', {'password': hashedPassword},
        where: 'username = ?', whereArgs: [username]);
    return count > 0;
  }

  Future<bool> eliminarUsuario(String username) async {
    final db = await database;
    int count = await db.delete('users', where: 'username = ?', whereArgs: [username]);
    return count > 0;
  }

  Future<List<Map<String, dynamic>>> listarUsuarios() async {
    final db = await database;
    return await db.query('users', columns: ['id', 'username']);
  }

  Future<void> cerrarCBaseUsuarios() async {
    final db = await database;
    await db.close();
  }
}
