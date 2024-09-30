#!/usr/bin/env python3

import flet as ft
from datetime import datetime
from Controladores_bases.Controlador import Inventario, Articulo


def mostrar_inventario(page, db):
    inventario_controller = Inventario(db)
    articulo_controller = Articulo(db)

    def obtener_inventario():
        inventario_list = inventario_controller.obtener_todos_los_movimientos()
        articulos = []
        #print(f"{inventario_list}")  # Espacio para depurar la obtencion del inventario
        for transaccion in inventario_list:
            articulo = articulo_controller.obtener_articulo_por_nombre(transaccion['id_articulo'])
            if articulo:  # condicional para ejecutar solo si existe
                articulos.append({
                    'id_transaccion': transaccion['id_transaccion'],
                    'nombre': articulo['nombre'],
                    'especificacion': articulo['especificacion'],
                    'cantidad': transaccion['cantidad'],
                    'fecha': transaccion['fecha'],
                    'notas': transaccion['notas'],
                })
        return articulos

    def generar_tabla_inventario():
        filas = []
        articulos = obtener_inventario()
        for transaccion in articulos:
            fila = ft.DataRow(
                cells=[
                    ft.DataCell(ft.Text(transaccion["nombre"])),
                    ft.DataCell(ft.Text(str(transaccion["cantidad"]))),
                    ft.DataCell(ft.Text(transaccion["fecha"])),
                    ft.DataCell(ft.Text(transaccion["notas"] if transaccion["notas"] else "")),
                    ft.DataCell(ft.IconButton(icon=ft.icons.EDIT, on_click=lambda e, id_transaccion=transaccion["id_transaccion"]: actualizar_articulo(id_transaccion))),
                    ft.DataCell(ft.IconButton(icon=ft.icons.DELETE, on_click=lambda e, id_transaccion=transaccion["id_transaccion"]: eliminar_articulo(id_transaccion)))  # Se modifica la captura de los datos
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

            fecha_actual = datetime.now().strftime("%Y-%m-%d")
            inventario_controller.crear_transaccion(id_articulo, 1, cantidad, fecha_actual, notas)
            #print("Movimiento registrado con éxito.")
            actualizar_tabla()

        except Exception as ex:
            print(f"Error al registrar movimiento: {ex}")

    def actualizar_articulo(id_transaccion):
        # queda pendiente implementar logica aqui
        print(f"Actualizar artículo con ID: {id_transaccion}")

    def eliminar_articulo(id_transaccion):
        try:
            # en esta parte se elimina la transaccion
            inventario_controller.eliminar_transaccion(id_transaccion)
           # print(f"Transacción {id_transaccion} eliminada con éxito.")
            actualizar_tabla()  # se actualiza la tabla
        except Exception as ex:
            print(f"Error al eliminar la transacción: {ex}")

    def actualizar_tabla():
        tabla_contenido.rows = generar_tabla_inventario()
        #print(f"Tabla actualizada con filas: {tabla_contenido.rows}")  # mensaje de depuracion para la actualizacion de la tabla
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
            ft.DataColumn(ft.Text("Artículo")),
            ft.DataColumn(ft.Text("Cantidad")),
            ft.DataColumn(ft.Text("Fecha")),
            ft.DataColumn(ft.Text("Notas")),
            ft.DataColumn(ft.Text("Acciones")),
            ft.DataColumn(ft.Text("Acciones2"))
        ],
        rows=generar_tabla_inventario()
    )

    # aqui esta el contenedor con el scroll para la tabla
    contenedor_scroll = ft.Column(
        controls=[tabla_contenido],
        height=300,  # Altura del contenedor
        scroll="auto"  # Activar scroll
    )

    # aqui esta la interface principal
    return ft.Column(
        controls=[
            ft.Text("Gestión de Inventario", style="headlineMedium"),
            articulo_dropdown,
            cantidad_input,
            notas_input,
            registrar_button,
            contenedor_scroll  # Contenedor con scroll para la tabla
        ]
    )

