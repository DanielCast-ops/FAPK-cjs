import sqlite3
from passlib.hash import argon2

class base_usuario:
    def __init__(self, db_name="usuarios.db"):
        # aqui se conecta  la base de datos con python
        self.conn = sqlite3.connect(db_name, check_same_thread=False)
        self.cursor = self.conn.cursor()
        self.crear_tabla()

    def crear_tabla(self):
        # aqui se crean las tablas necesarias
        self.cursor.execute('''CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
        )''')
        self.conn.commit()

    def registrar_usuario(self, username, password):
        # aqui se crea el usuario con pass hasheado para seguridad
        hashed = argon2.hash(password)
        try:
            self.cursor.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, hashed))
            self.conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False

    def verificar_login(self, username, password):
        # una funcion para verificar el login
        self.cursor.execute("SELECT password FROM users WHERE username=?", (username,))
        result = self.cursor.fetchone()
        if result:
            stored_password = result[0]
            return argon2.verify(password, stored_password)
        return False

    def Consultar_usuario(self, username):
        # aqui esta la funcion para consulta
        self.cursor.execute("SELECT id, username FROM users WHERE username=?", (username,))
        return self.cursor.fetchone()

    def actualizar_usuario(self, username, new_password):
        # aqui esta la funcion para editar la key
        hashed = argon2.hash(new_password)
        self.cursor.execute("UPDATE users SET password=? WHERE username=?", (hashed, username))
        self.conn.commit()
        return self.cursor.rowcount > 0

    def eliminar_usuario(self, username):
        # una funcion para eliminar usuarios
        self.cursor.execute("DELETE FROM users WHERE username=?", (username,))
        self.conn.commit()
        return self.cursor.rowcount > 0

    def listar_usuarios(self):
        # aqui una funcion para que se listen todos los usuarios
        self.cursor.execute("SELECT id, username FROM users")
        return self.cursor.fetchall()

    def cerrar_c_base_usuarios(self):
        # Cerrar la conexión a la base de datos
        self.conn.close()
