#!/usr/bin/env python3

from Controladores_bases.Controlador import Inventario

# Nombre de la base de datos
db = 'cjs.db'

# Crear instancia del controlador de inventario
inventario_controller = Inventario(db)

# ID del artículo que quieres consultar
id_articulo = "p"  # Cambia esto por el ID real del artículo que quieras consultar

# Obtener la cantidad total del artículo
try:
    cantidad = inventario_controller.obtener_cantidad_articulo(id_articulo)
    print(f"La cantidad total del artículo con ID {id_articulo} es: {cantidad}")
except Exception as e:
    print(f"Error al obtener la cantidad del artículo: {e}")

