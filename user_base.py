import sqlite3
import bcrypt

class UserDatabase:
    def __init__(self, db_name="users.db"):
        # aqui conecto la base de datos con python
        self.conn = sqlite3.connect(db_name)
        self.cursor = self.conn.cursor()
        self.create_table()

    def create_table(self):
        # aqui creo las tablas necesarias
        self.cursor.execute('''CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
        )''')
        self.conn.commit()

    def register_user(self, username, password):
        # aqui se crea el usuario con pass hasheado para seguridad
        hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        try:
            self.cursor.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, hashed))
            self.conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False

    def verify_login(self, username, password):
        # una funcion para verificar el login
        self.cursor.execute("SELECT password FROM users WHERE username=?", (username,))
        result = self.cursor.fetchone()
        if result:
            stored_password = result[0]
            return bcrypt.checkpw(password.encode('utf-8'), stored_password.encode('utf-8'))
        return False

    def get_user(self, username):
        # una funcion para consulta
        self.cursor.execute("SELECT id, username FROM users WHERE username=?", (username,))
        return self.cursor.fetchone()

    def update_user(self, username, new_password):
        # una funcion para editar la kay
        hashed = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())
        self.cursor.execute("UPDATE users SET password=? WHERE username=?", (hashed, username))
        self.conn.commit()
        return self.cursor.rowcount > 0

    def delete_user(self, username):
        # una funcion para eliminar usuarios
        self.cursor.execute("DELETE FROM users WHERE username=?", (username,))
        self.conn.commit()
        return self.cursor.rowcount > 0

    def list_users(self):
        # Una funcion para registrar
        self.cursor.execute("SELECT id, username FROM users")
        return self.cursor.fetchall()

    def close(self):
        # Cerrar la conexión a la base de datos
        self.conn.close()

