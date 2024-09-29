#!/usr/bin/env python3

import flet as ft
from Controladores_bases.Controlador import Inventario, Articulo


def mostrar_inventario(page, db):
    inventario_controller = Inventario(db)
    articulo_controller = Articulo(db)

    def obtener_inventario():
        # Aqui obtengo  el inventario actual desde la base de datos
        inventario_list = inventario_controller.obtener_todos_los_movimientos()
        articulos = []
        for transaccion in inventario_list:
            cantidad = inventario_controller.obtener_cantidad_articulo(transaccion['id_articulo'])
            articulo = articulo_controller.obtener_articulo_por_nombre(transaccion['id_articulo'])
            #print(f"cantidad {cantidad} articulo: {articulo}")
            if articulo:  # Solo si el artículo existe
                articulos.append({
                    'id_transaccion': transaccion['id_transaccion'],
                    'nombre': articulo['nombre'],
                    'especificacion': articulo['especificacion'],
                    'cantidad': cantidad,
                    'fecha': transaccion['fecha'],
                    'notas': transaccion['notas'],
                })
        print(f"Inventario obtenido: {articulos}")  #Este es un mensaje de depuracion.
        return articulos

    def generar_tabla_inventario():
        filas = []
        articulos = obtener_inventario()  # aqui se obtienen los datos actualizados para las columnas
        for transaccion in articulos:
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

    def registrar_movimiento(e):
        try:
            id_articulo = articulo_dropdown.value
            cantidad = int(cantidad_input.value)
            notas = notas_input.value

            if not id_articulo or cantidad <= 0:
                print("Error: El artículo no es válido o la cantidad es menor o igual a cero.")
                return

            inventario_controller.crear_transaccion(id_articulo, 1, cantidad, "2024-09-26", notas)
            print("Movimiento registrado con éxito.") mensaje de depuracion
            actualizar_tabla()
        except Exception as ex:
            print(f"Error al registrar movimiento: {ex}")

    def actualizar_articulo(id_transaccion):
        pass  # Implementar lógica de actualización

    def eliminar_articulo(id_transaccion):
        inventario_controller.eliminar_transaccion(id_transaccion)
        actualizar_tabla()

    def actualizar_tabla():
        tabla_contenido.rows = generar_tabla_inventario()
        print(f"Tabla actualizada con filas: {tabla_contenido.rows}")  # Mensaje de depuración
        page.update()

    articulo_dropdown = ft.Dropdown(
        options=[ft.dropdown.Option(text=articulo['nombre'], data=articulo['id_articulo'])
                 for articulo in articulo_controller.obtener_todos_los_articulos()]
    )

    cantidad_input = ft.TextField(label="Cantidad")
    notas_input = ft.TextField(label="Notas (opcional)")
    registrar_button = ft.ElevatedButton(text="Registrar Movimiento", on_click=registrar_movimiento)

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

