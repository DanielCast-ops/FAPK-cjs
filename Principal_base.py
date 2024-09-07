#!/usr/bin/env python3

#importamos la librería
import sqlite3

# Creamos y conectamos la base de datos.
def conexionycreacion(base):
    con = sqlite3.connect(base)
    # Creamos el cursor
    cursor = con.cursor()

    # Creamos las tablas
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS cargos (
            id_cargo INTEGER PRIMARY KEY AUTOINCREMENT,
            cargo VARCHAR(20) NOT NULL
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS clientes (
            id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre VARCHAR(50) NOT NULL,
            telefono VARCHAR(15) NOT NULL
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS proveedores (
            id_proveedor INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre VARCHAR(50) NOT NULL,
            telefono VARCHAR(15) NOT NULL,
            tipo_de_productos VARCHAR(100)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS empleados (
            id_personal INTEGER PRIMARY KEY,
            nombre VARCHAR(50) NOT NULL,
            id_cargo INTEGER NOT NULL,
            telefono VARCHAR(15) NOT NULL,
            FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS articulos (
            id_articulo INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre VARCHAR(50) NOT NULL,
            especificacion VARCHAR(200),
            id_proveedor INTEGER NOT NULL,
            FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS inventario (
            id_transaccion INTEGER PRIMARY KEY AUTOINCREMENT,
            id_articulo INTEGER NOT NULL,
            id_personal INTEGER NOT NULL,
            cantidad INTEGER NOT NULL,
            fecha DATE NOT NULL,
            notas VARCHAR(200),
            FOREIGN KEY (id_articulo) REFERENCES articulos(id_articulo),
            FOREIGN KEY (id_personal) REFERENCES empleados(id_personal)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS servicios (
            id_servicio INTEGER PRIMARY KEY,
            nombre VARCHAR(50) NOT NULL,
            fecha DATE NOT NULL,
            telefono_extra VARCHAR(45),
            cliente_id INTEGER NOT NULL,
            personal_id INTEGER NOT NULL,
            FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente),
            FOREIGN KEY (personal_id) REFERENCES empleados(id_personal)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS estado_servicio (
            id_estado INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion VARCHAR(50) NOT NULL
        )
    ''')

    con.commit()

    print("Se han creado las tablas")

    # Cerramos la conexión
    con.close()

# Definimos la función para usarla desde nuestro script principal
def crear_base(base):
    conexionycreacion(base)

