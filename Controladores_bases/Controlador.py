#!/usr/bin/env python3

#importamos librerias

import sqlite3

#creamos la clase que contrlara la  base de datos utilizando POO
#se editan los hilos para poder manejar los datos

class base_de_datos:
    def __init__(self, nombredb):
        self.nombredb = nombredb

    def ejecutar_consulta(self, consulta, parametros=()):
        conexion = sqlite3.connect(self.nombredb)
        cursor = conexion.cursor()
        cursor.execute(consulta, parametros)
        resultados = cursor.fetchall()
        conexion.close()
        return resultados

 #realizamos funcion que nos permita ajecutar diferentes sentencias (incert, delete, update etc.)

    def ejecutar_sentencia(self, sentencia, parametros=()):
        conexion = sqlite3.connect(self.nombredb)
        cursor = conexion.cursor()
        cursor.execute(sentencia, parametros)
        conexion.commit()
        lastrowid = cursor.lastrowid
        conexion.close()
        return lastrowid

#creamos funcion que cierre la coneccion

    def cerrar_conexion(self):
        pass  # No necesitamos cerrar la conexión aquí


#creamos cada una de las clases que se encargara de manejar las tablas de la bd.

# clase cargo

class Cargo:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_cargo(self, cargo):
        consulta = 'INSERT INTO cargos (cargo) VALUES (?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (cargo,))

    def obtener_cargo(self, id_cargo):
        consulta = 'SELECT * FROM cargos WHERE id_cargo = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_cargo,))
        if resultado:
            return {'id_cargo': resultado[0][0], 'cargo': resultado[0][1]}
        else:
            return None

    def actualizar_cargo(self, id_cargo, nuevo_cargo):
        consulta = 'UPDATE cargos SET cargo = ? WHERE id_cargo = ?'
        self.base_de_datos.realizar_sentencia(consulta, (nuevo_cargo, id_cargo))

    def eliminar_cargo(self, id_cargo):
        consulta = 'DELETE FROM cargos WHERE id_cargo = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_cargo,))

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

#clase cliente

class Cliente:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_cliente(self, nombre, telefono):
        consulta = 'INSERT INTO clientes (nombre, telefono) VALUES (?, ?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (nombre, telefono))

    def obtener_cliente(self, id_cliente):
        consulta = 'SELECT * FROM clientes WHERE id_cliente = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_cliente,))
        if resultado:
            return {'id_cliente': resultado[0][0], 'nombre': resultado[0][1], 'telefono': resultado[0][2]}
        else:
            return None

    def actualizar_cliente(self, id_cliente, nuevo_nombre, nuevo_telefono):
        consulta = 'UPDATE clientes SET nombre = ?, telefono = ? WHERE id_cliente = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nuevo_nombre, nuevo_telefono, id_cliente))

    def eliminar_cliente(self, id_cliente):
        consulta = 'DELETE FROM clientes WHERE id_cliente = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_cliente,))

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

#clase proveedor

class Proveedor:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_proveedor(self, nombre, telefono, tipo_de_productos=None):
        consulta = 'INSERT INTO proveedores (nombre, telefono, tipo_de_productos) VALUES (?, ?, ?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (nombre, telefono, tipo_de_productos))

    def obtener_proveedor(self, id_proveedor):
        consulta = 'SELECT * FROM proveedores WHERE id_proveedor = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_proveedor,))
        if resultado:
            return {'id_proveedor': resultado[0][0], 'nombre': resultado[0][1], 'telefono': resultado[0][2], 'tipo_de_productos': resultado[0][3]}
        else:
            return None

    def actualizar_proveedor(self, id_proveedor, nuevo_nombre, nuevo_telefono, nuevo_tipo_de_productos):
        consulta = 'UPDATE proveedores SET nombre = ?, telefono = ?, tipo_de_productos = ? WHERE id_proveedor = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nuevo_nombre, nuevo_telefono, nuevo_tipo_de_productos, id_proveedor))

    def eliminar_proveedor(self, id_proveedor):
        consulta = 'DELETE FROM proveedores WHERE id_proveedor = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_proveedor,))

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

#clase empleado

class Empleado:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_empleado(self, nombre, id_cargo, telefono):
        consulta = 'INSERT INTO empleados (nombre, id_cargo, telefono) VALUES (?, ?, ?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (nombre, id_cargo, telefono))

    def obtener_empleado(self, id_personal):
        consulta = 'SELECT * FROM empleados WHERE id_personal = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_personal,))
        if resultado:
            return {'id_personal': resultado[0][0], 'nombre': resultado[0][1], 'id_cargo': resultado[0][2], 'telefono': resultado[0][3]}
        else:
            return None

    def actualizar_empleado(self, id_personal, nuevo_nombre, nuevo_id_cargo, nuevo_telefono):
        consulta = 'UPDATE empleados SET nombre = ?, id_cargo = ?, telefono = ? WHERE id_personal = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nuevo_nombre, nuevo_id_cargo, nuevo_telefono, id_personal))

    def eliminar_empleado(self, id_personal):
        consulta = 'DELETE FROM empleados WHERE id_personal = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_personal,))

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

#clase articulo

class Articulo:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_articulo(self, nombre, especificacion, id_proveedor):
        consulta = 'INSERT INTO articulos (nombre, especificacion, id_proveedor) VALUES (?, ?, ?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (nombre, especificacion, id_proveedor))

    def obtener_articulo(self, id_articulo):
        consulta = 'SELECT * FROM articulos WHERE id_articulo = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_articulo,))
        if resultado:
            return {'id_articulo': resultado[0][0], 'nombre': resultado[0][1], 'especificacion': resultado[0][2], 'id_proveedor': resultado[0][3]}
        else:
            return None
    def obtener_articulo_por_nombre(self, nombre_articulo):
        consulta = 'SELECT * FROM articulos WHERE nombre = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (nombre_articulo,))
        if resultado:
            return {'id_articulo': resultado[0][0], 'nombre': resultado[0][1], 'especificacion': resultado[0][2], 'id_proveedor': resultado[0][3]}
        else:
            return None

    def actualizar_articulo(self, id_articulo, nuevo_nombre, nueva_especificacion, nuevo_id_proveedor):
        consulta = 'UPDATE articulos SET nombre = ?, especificacion = ?, id_proveedor = ? WHERE id_articulo = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nuevo_nombre, nueva_especificacion, nuevo_id_proveedor, id_articulo))

    def eliminar_articulo(self, id_articulo):
        consulta = 'DELETE FROM articulos WHERE id_articulo = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_articulo,))

    def obtener_todos_los_articulos(self): #creo la clase para obtener todos los articulos
        consulta = 'SELECT * FROM articulos'
        resultados = self.base_de_datos.ejecutar_consulta(consulta)
        return [{'id_articulo': r[0], 'nombre': r[1], 'especificacion': r[2], 'id_proveedor': r[3]} for r in resultados]

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

#clase inventario

class Inventario:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_transaccion(self, id_articulo, id_personal, cantidad, fecha, notas=None):
        consulta = 'INSERT INTO inventario (id_articulo, id_personal, cantidad, fecha, notas) VALUES (?, ?, ?, ?, ?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (id_articulo, id_personal, cantidad, fecha, notas))

    def obtener_transaccion(self, id_transaccion):
        consulta = 'SELECT * FROM inventario WHERE id_transaccion = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_transaccion,))
        if resultado:
            return {'id_transaccion': resultado[0][0], 'id_articulo': resultado[0][1], 'id_personal': resultado[0][2], 'cantidad': resultado[0][3], 'fecha': resultado[0][4], 'notas': resultado[0][5]}
        else:
            return None

    def actualizar_transaccion(self, id_transaccion, nuevo_id_articulo, nuevo_id_personal, nueva_cantidad, nueva_fecha, nuevas_notas):
        consulta = 'UPDATE inventario SET id_articulo = ?, id_personal = ?, cantidad = ?, fecha = ?, notas = ? WHERE id_transaccion = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nuevo_id_articulo, nuevo_id_personal, nueva_cantidad, nueva_fecha, nuevas_notas, id_transaccion))

    def eliminar_transaccion(self, id_transaccion):
        consulta = 'DELETE FROM inventario WHERE id_transaccion = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_transaccion,))

    def obtener_cantidad_articulo(self, id_articulo): #se agrega una funcion para saber la cantidad real de un determinado articulo
        consulta = 'SELECT SUM(cantidad) FROM inventario WHERE id_articulo = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_articulo,))
        return resultado[0][0] if resultado[0][0] is not None else 0

    def obtener_todos_los_movimientos(self): #incerto este otro metodo facilitar la consulta de todo el inventario
        consulta = 'SELECT * FROM inventario ORDER BY id_transaccion DESC'
        resultados = self.base_de_datos.ejecutar_consulta(consulta)
        return [{'id_transaccion': r[0], 'id_articulo': r[1], 'id_personal': r[2], 'cantidad': r[3], 'fecha': r[4], 'notas': r[5]} for r in resultados]

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

#clase servicio

class Servicio:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_servicio(self, nombre, fecha, telefono_extra, cliente_id, id_personal):
        consulta = 'INSERT INTO servicios (nombre, fecha, telefono_extra, cliente_id, id_personal) VALUES (?, ?, ?, ?, ?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (nombre, fecha, telefono_extra, cliente_id, id_personal))

    def obtener_servicio(self, id_servicio):
        consulta = 'SELECT * FROM servicios WHERE id_servicio = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_servicio,))
        if resultado:
            return {'id_servicio': resultado[0][0], 'nombre': resultado[0][1], 'fecha': resultado[0][2], 'telefono_extra': resultado[0][3], 'cliente_id': resultado[0][4], 'id_personal': resultado[0][5]}
        else:
            return None

    def actualizar_servicio(self, id_servicio, nuevo_nombre, nueva_fecha, nuevo_telefono_extra, nuevo_cliente_id, nuevo_id_personal):
        consulta = 'UPDATE servicios SET nombre = ?, fecha = ?, telefono_extra = ?, cliente_id = ?, id_personal = ? WHERE id_servicio = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nuevo_nombre, nueva_fecha, nuevo_telefono_extra, nuevo_cliente_id, nuevo_id_personal, id_servicio))

    def eliminar_servicio(self, id_servicio):
        consulta = 'DELETE FROM servicios WHERE id_servicio = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_servicio,))

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()

class EstadoServicio:
    def __init__(self, nombredb):
        self.base_de_datos = base_de_datos(nombredb)

    def crear_estado_servicio(self, descripcion):
        consulta = 'INSERT INTO estado_servicio (descripcion) VALUES (?)'
        return self.base_de_datos.ejecutar_sentencia(consulta, (descripcion,))

    def obtener_estado_servicio(self, id_estado):
        consulta = 'SELECT * FROM estado_servicio WHERE id_estado = ?'
        resultado = self.base_de_datos.ejecutar_consulta(consulta, (id_estado,))
        if resultado:
            return {'id_estado': resultado[0][0], 'descripcion': resultado[0][1]}
        else:
            return None

    def actualizar_estado_servicio(self, id_estado, nueva_descripcion):
        consulta = 'UPDATE estado_servicio SET descripcion = ? WHERE id_estado = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (nueva_descripcion, id_estado))

    def eliminar_estado_servicio(self, id_estado):
        consulta = 'DELETE FROM estado_servicio WHERE id_estado = ?'
        self.base_de_datos.ejecutar_sentencia(consulta, (id_estado,))

    def cerrar_conexion(self):
        self.base_de_datos.cerrar_conexion()


