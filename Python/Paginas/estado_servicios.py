#!/usr/bin/env python3

import flet as ft
from Controladores_bases.Controlador import EstadoServicio

db = 'cjs.db'
estado_controller = EstadoServicio(db)

estado_seleccionado = None

def gestion_estados_servicios(page):
    page.title = "Gestión de Estados de Servicios"
    page.scroll = "auto"

    def obtener_estados():
        """Función que obtiene los estados disponibles en la base de datos."""
        return estado_controller.obtener_todos_los_estados()

    def generar_tabla_estados():
        """Generar las filas para la tabla de estados."""
        filas = []
        estados = obtener_estados()
        for estado in estados:
            fila = ft.DataRow(
                cells=[
                    ft.DataCell(ft.Text(estado["descripcion"])),
                    ft.DataCell(ft.IconButton(icon=ft.icons.EDIT, on_click=lambda e, id_estado=estado["id_estado"]: editar_estado(id_estado))),
                    ft.DataCell(ft.IconButton(icon=ft.icons.DELETE, on_click=lambda e, id_estado=estado["id_estado"]: eliminar_estado(id_estado)))
                ]
            )
            filas.append(fila)
        return filas

    def agregar_estado(e):
        """Agregar un nuevo estado a la base de datos."""
        descripcion = descripcion_input.value
        if descripcion.strip():
            estado_controller.crear_estado_servicio(descripcion)
            descripcion_input.value = ""
            actualizar_tabla()
        else:
            print("Error: La descripción del estado no puede estar vacía.")

    def editar_estado(id_estado):
        """Cargar los datos del estado seleccionado para editar."""
        global estado_seleccionado
        estado_seleccionado = estado_controller.obtener_estado_servicio(id_estado)
        if estado_seleccionado:
            descripcion_input.value = estado_seleccionado["descripcion"]
            guardar_button.visible = True
            agregar_button.visible = False
            page.update()

    def guardar_cambios(e):
        """Guardar los cambios después de editar un estado."""
        global estado_seleccionado
        if estado_seleccionado:
            descripcion_actualizada = descripcion_input.value
            if descripcion_actualizada.strip():
                estado_controller.actualizar_estado_servicio(
                    estado_seleccionado["id_estado"], descripcion_actualizada
                )
                limpiar_formulario()
                actualizar_tabla()
            else:
                print("Error: La descripción del estado no puede estar vacía.")

    def eliminar_estado(id_estado):
        """Eliminar un estado de la base de datos."""
        estado_controller.eliminar_estado_servicio(id_estado)
        actualizar_tabla()

    def limpiar_formulario():
        """Limpiar el formulario y restaurar los botones."""
        descripcion_input.value = ""
        guardar_button.visible = False
        agregar_button.visible = True
        page.update()

    def actualizar_tabla():
        """Actualizar la tabla de estados con los datos actuales."""
        tabla_contenido.rows = generar_tabla_estados()
        page.update()

    # interfaz
    descripcion_input = ft.TextField(label="Descripción del Estado", width=300)
    agregar_button = ft.ElevatedButton("Agregar Estado", on_click=agregar_estado)
    guardar_button = ft.ElevatedButton("Guardar Cambios", on_click=guardar_cambios, visible=False)

    tabla_contenido = ft.DataTable(
        columns=[
            ft.DataColumn(ft.Text("Descripción")),
            ft.DataColumn(ft.Text("Editar")),
            ft.DataColumn(ft.Text("Eliminar")),
        ],
        rows=generar_tabla_estados()
    )

    contenedor_scroll = ft.Column(
        controls=[tabla_contenido],
        height=300,
        scroll="auto"
    )

    return ft.Column(
        controls=[
            ft.Text("Gestión de Estados de Servicios", style="headlineMedium"),
            descripcion_input,
            ft.Row([agregar_button, guardar_button]),
            contenedor_scroll
        ]
    )

