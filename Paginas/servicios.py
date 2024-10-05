import flet as ft
from Controladores_bases.Controlador import Servicio, EstadoServicio
from datetime import datetime
import logging

db = 'cjs.db'
servicio_controller = Servicio(db)
estado_controller = EstadoServicio(db)

def administracion_servicios(page):
    modo_edicion = False
    id_servicio_actual = None
    def mostrar_historial_servicios():
        try:
            servicios = servicio_controller.obtener_todos_los_servicios()
            return [
                ft.Card(
                    content=ft.Container(
                        content=ft.Column([
                            ft.ListTile(
                                leading=ft.Icon(ft.icons.WORK),
                                title=ft.Text(servicio['nombre'], weight=ft.FontWeight.BOLD),
                                subtitle=ft.Text(f"Fecha: {servicio['fecha']} | Detalles: {servicio['detalles']}"),
                            ),
                            ft.Text(f"Estado: {obtener_nombre_estado(servicio['estado_id'])}"),
                            ft.Row([
                                ft.ElevatedButton("Editar", icon=ft.icons.EDIT,
                                                  on_click=lambda _, id=servicio['id_servicio']: editar_servicio(id)),
                                ft.ElevatedButton("Eliminar", icon=ft.icons.DELETE,
                                                  on_click=lambda _, id=servicio['id_servicio']: eliminar_servicio(id)),
                            ], alignment=ft.MainAxisAlignment.END)
                        ]),
                        padding=10
                    ),
                    margin=10
                ) for servicio in servicios
            ]
        except Exception as e:
            print(f"Error al obtener servicios: {e}")
            return []

    def obtener_nombre_estado(estado_id):
        estado = estado_controller.obtener_estado_servicio(estado_id)
        return estado['descripcion'] if estado else "Desconocido"

    lista_servicios = ft.Column([], scroll=ft.ScrollMode.AUTO, expand=True)

    def actualizar_lista():
        lista_servicios.controls = mostrar_historial_servicios()
        page.update()

    # todos los estados
    estados = estado_controller.obtener_todos_los_estados()
    opciones_estado = [ft.dropdown.Option(estado['id_estado'], estado['descripcion']) for estado in estados]

    # campos para agregar o editar
    nombre_input = ft.TextField(label="Nombre del Servicio", expand=True)
    fecha_input = ft.TextField(label="Fecha (YYYY-MM-DD)", expand=True, value=datetime.now().strftime("%Y-%m-%d"))
    telefono_input = ft.TextField(label="Teléfono Extra", expand=True)
    detalles_input = ft.TextField(label="Detalles del Servicio", expand=True)
    estado_dropdown = ft.Dropdown(
        label="Estado del Servicio",
        options=opciones_estado,
        width=200,
    )
    message = ft.Text()

    def agregar_servicio(e):
        nombre = nombre_input.value
        fecha = fecha_input.value
        telefono_extra = telefono_input.value
        detalles = detalles_input.value
        estado_id = estado_dropdown.value
        cliente_id = '1'
        personal_id = '1'

        if servicio_controller.crear_servicio(nombre, fecha, telefono_extra, detalles, estado_id, cliente_id, personal_id):
            message.value = "Servicio creado exitosamente."
            nombre_input.value = ""
            fecha_input.value = datetime.now().strftime("%Y-%m-%d")
            telefono_input.value = ""
            detalles_input.value = ""
            estado_dropdown.value = None
            actualizar_lista()
        else:
            message.value = "Error al crear el servicio."
        page.update()

    def eliminar_servicio(id_servicio):
        servicio_controller.eliminar_servicio(id_servicio)
        message.value = "Servicio eliminado."
        actualizar_lista()

    def editar_servicio(id_servicio):
        nonlocal modo_edicion, id_servicio_actual
        servicio = servicio_controller.obtener_servicio(id_servicio)
        if servicio:
            nombre_input.value = servicio['nombre']
            fecha_input.value = servicio['fecha']
            telefono_input.value = servicio['telefono_extra']
            detalles_input.value = servicio['detalles']
            estado_dropdown.value = servicio['estado_id']
            modo_edicion = True
            id_servicio_actual = id_servicio
            boton_accion.text = "Actualizar Servicio"
            boton_accion.icon = ft.icons.UPDATE
        page.update()

    def guardar_o_actualizar_servicio(e):
        nonlocal modo_edicion, id_servicio_actual
        nombre = nombre_input.value
        fecha = fecha_input.value
        telefono_extra = telefono_input.value
        detalles = detalles_input.value
        estado_id = estado_dropdown.value
        cliente_id = '1'
        personal_id = '1'

        if modo_edicion:
            try:
                resultado = servicio_controller.actualizar_servicio(id_servicio_actual, nombre, fecha, telefono_extra, detalles, estado_id, cliente_id, personal_id)
                if resultado:
                    message.value = "Servicio actualizado exitosamente."
                    modo_edicion = False
                    id_servicio_actual = None
                    boton_accion.text = "Agregar Servicio"
                    boton_accion.icon = ft.icons.ADD
                else:
                    message.value = "No se pudo actualizar el servicio. No se encontró el servicio o no hubo cambios."
            except Exception as e:
                message.value = f"Error al actualizar el servicio: {str(e)}"
        else:
            try:
                resultado = servicio_controller.crear_servicio(nombre, fecha, telefono_extra, detalles, estado_id, cliente_id, personal_id)
                if resultado:
                    message.value = "Servicio creado exitosamente."
                else:
                    message.value = "No se pudo crear el servicio. Verifica los datos."
            except Exception as e:
                message.value = f"Error al crear el servicio: {str(e)}"

        nombre_input.value = ""
        fecha_input.value = datetime.now().strftime("%Y-%m-%d")
        telefono_input.value = ""
        detalles_input.value = ""
        estado_dropdown.value = None
        actualizar_lista()
        page.update()

    # boton para (Agregar o Actualizar)
    boton_accion = ft.ElevatedButton("Agregar Servicio", on_click=guardar_o_actualizar_servicio, icon=ft.icons.ADD)

    vista = ft.View(
        "/administrar_servicios",
        [
            ft.AppBar(title=ft.Text("Administración de Servicios"), bgcolor=ft.colors.BLUE),
            ft.Container(
                content=ft.Column([
                    ft.Text("Agregar/Editar Servicio", size=20, weight=ft.FontWeight.BOLD),
                    ft.Row([nombre_input, fecha_input, telefono_input], expand=True),
                    ft.Row([detalles_input, estado_dropdown], expand=True),
                    boton_accion,
                    message,
                ]),
                padding=20,
            ),
            ft.Divider(),
            ft.Text("Servicios Registrados", size=20, weight=ft.FontWeight.BOLD),
            lista_servicios,
        ],
        scroll=ft.ScrollMode.AUTO
    )

    actualizar_lista()
    return vista
