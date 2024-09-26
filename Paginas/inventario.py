#!/usr/bin/env python3

import flet as ft
from Controladores_bases.Controlador import Inventario, Articulo

def mostrar_inventario(page, db):  # Asegúrate de recibir el 'page' como argumento
    # Instancio el controlador
    inventario_controller = Inventario(db)
    articulo_controller = Articulo(db)

    # Una función para obtener el inventario actual
    def obtener_inventario():
        inventario_list = inventario_controller.obtener_todos_los_movimientos()

        articulos = []  # Lista para almacenar los artículos y sus cantidades
        for transaccion in inventario_list:
            cantidad = inventario_controller.obtener_cantidad_articulo(transaccion['id_articulo'])
            articulo = articulo_controller.obtener_articulo(transaccion['id_articulo'])
            if articulo:  # Solo si el artículo existe
                articulos.append({
                    'id_transaccion': transaccion['id_transaccion'],
                    'nombre': articulo['nombre'],
                    'especificacion': articulo['especificacion'],
                    'cantidad': cantidad,
                    'fecha': transaccion['fecha'],
                    'notas': transaccion['notas'],
                })

        return articulos

    # Aquí una tabla para insertar los datos.
    def generar_tabla_inventario():
        filas = []
        for transaccion in obtener_inventario():
            fila = ft.DataRow(
                cells=[
                    ft.DataCell(ft.Text(transaccion["nombre"])),
                    ft.DataCell(ft.Text(transaccion["especificacion"])),
                    ft.DataCell(ft.Text(str(transaccion["cantidad"]))),
                    ft.DataCell(ft.Text(transaccion["fecha"])),
                    ft.DataCell(ft.Text(transaccion["notas"] if transaccion["notas"] else "")),
                    ft.DataCell(ft.IconButton(icon=ft.icons.EDIT, on_click=lambda e: actualizar_articulo(transaccion["id_transaccion"]))),
                    ft.DataCell(ft.IconButton(icon=ft.icons.DELETE, on_click=lambda e: eliminar_articulo(transaccion["id_transaccion"])))
                ]
            )
            filas.append(fila)
        return filas

    # Aquí una función para registrar un nuevo movimiento
    def registrar_movimiento(e):
        id_articulo = articulo_dropdown.value
        cantidad = int(cantidad_input.value)
        notas = notas_input.value
        inventario_controller.crear_transaccion(id_articulo, 1, cantidad, "2024-09-26", notas)
        actualizar_tabla()

    # Aquí debe ir la función para actualizar el inventario
    def actualizar_articulo(id_transaccion):
        # Revisar la lógica para actualizar un movimiento existente
        pass

    # Función para eliminar un registro de inventario
    def eliminar_articulo(id_transaccion):
        inventario_controller.eliminar_transaccion(id_transaccion)
        actualizar_tabla()

    # Función para actualizar la tabla de inventario
    def actualizar_tabla():
        tabla_contenido.rows = generar_tabla_inventario()
        page.update()

    # Presentación de la página

    articulo_dropdown = ft.Dropdown(
    options=[ft.dropdown.Option(text=articulo['nombre'], data=articulo['id_articulo'])
             for articulo in articulo_controller.obtener_todos_los_articulos()])

    cantidad_input = ft.TextField(label="Cantidad")
    notas_input = ft.TextField(label="Notas (opcional)")

    registrar_button = ft.ElevatedButton(text="Registrar Movimiento", on_click=registrar_movimiento)

    # Layout de la página
    tabla_contenido = ft.DataTable(
        columns=[
            ft.DataColumn(label=ft.Text("Artículo")),
            ft.DataColumn(label=ft.Text("Especificación")),
            ft.DataColumn(label=ft.Text("Cantidad")),
            ft.DataColumn(label=ft.Text("Fecha")),
            ft.DataColumn(label=ft.Text("Notas")),
            ft.DataColumn(label=ft.Text("Acciones"))
        ],
        rows=generar_tabla_inventario()
    )

    # Combinamos todo en una columna
    return ft.Column(
        controls=[
            ft.Text("Gestión de Inventario", style="headlineMedium"),
            articulo_dropdown,
            cantidad_input,
            notas_input,
            registrar_button,
            tabla_contenido
        ]
    )

