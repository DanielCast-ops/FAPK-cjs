import flet as ft
from Controladores_bases.Controlador import Servicio, EstadoServicio

db = 'cjs.db'
servicio_controller = Servicio(db)
estado_controller = EstadoServicio(db)

def administracion_servicios(page):
    nombre_input = ft.TextField(label="Nombre del Servicio")
    fecha_input = ft.TextField(label="Fecha (YYYY-MM-DD)")
    telefono_input = ft.TextField(label="Teléfono Extra")
    #cliente_id_input = ft.TextField(label="ID del Cliente")
    #personal_id_input = ft.TextField(label="ID del Personal")
    message = ft.Text()

    # funcion para agregar servicio
    def agregar_servicio(e):
        nombre = nombre_input.value
        fecha = fecha_input.value
        telefono_extra = telefono_input.value
        cliente_id = "1"
        personal_id = "1"

        if servicio_controller.crear_servicio(nombre, fecha, telefono_extra, cliente_id, personal_id):
            message.value = "Servicio creado exitosamente."
            nombre_input.value = ""
            fecha_input.value = ""
            telefono_input.value = ""
            #cliente_id_input.value = ""
            #personal_id_input.value = ""
        else:
            message.value = "Error al crear el servicio."
        page.update()
    # aqui para mostrar el historial de servicios
    def mostrar_historial_servicios():
        servicios = servicio_controller.obtener_todos_los_servicios()
        filas = []
        for servicio in servicios:
            estado = estado_controller.obtener_estado_servicio(servicio['id_servicio'])
            filas.append(ft.DataRow(
                cells=[
                    ft.DataCell(ft.Text(servicio['nombre'])),
                    ft.DataCell(ft.Text(servicio['fecha'])),
                    ft.DataCell(ft.Text(estado['descripcion'] if estado else "Desconocido")),
                    ft.DataCell(ft.IconButton(icon=ft.icons.EDIT, on_click=lambda e, id=servicio['id_servicio']: editar_servicio(id))),
                    ft.DataCell(ft.IconButton(icon=ft.icons.DELETE, on_click=lambda e, id=servicio['id_servicio']: eliminar_servicio(id)))
                ]
            ))
        return filas

    def editar_servicio(id_servicio):
        servicio = servicio_controller.obtener_servicio(id_servicio)
        if servicio:
            nombre_input.value = servicio['nombre']
            fecha_input.value = servicio['fecha']
            telefono_input.value = servicio['telefono_extra']
            cliente_id_input.value = servicio['cliente_id']
            personal_id_input.value = servicio['id_personal']
        page.update()

    def eliminar_servicio(id_servicio):
        servicio_controller.eliminar_servicio(id_servicio)
        message.value = "Servicio eliminado."
        page.update()

    tabla_servicios = ft.DataTable(
        columns=[
            ft.DataColumn(ft.Text("Nombre")),
            ft.DataColumn(ft.Text("Fecha")),
            ft.DataColumn(ft.Text("Estado")),
            ft.DataColumn(ft.Text("Editar")),
            ft.DataColumn(ft.Text("Eliminar")),
        ],
        rows=mostrar_historial_servicios(),
        heading_text_style=ft.TextStyle(size=15),
        height=400,
        horizontal_lines=True,
        vertical_lines=True
    )

    # vista de la página
    return ft.View(
        "/administrar_servicios",
        [
            ft.Text("Administración de Servicios Técnicos", size=30),
            nombre_input,
            fecha_input,
            telefono_input,
            #cliente_id_input,
            #personal_id_input,
            ft.ElevatedButton("Agregar Servicio", on_click=agregar_servicio),
            tabla_servicios,
            message,
            ft.IconButton(icon=ft.icons.HOME, on_click=lambda _: page.go("/")),  # Navegar a la página principal
            ft.IconButton(icon=ft.icons.HISTORY, on_click=lambda _: page.go("/historico")),  # Ir a la página de historial
            ft.IconButton(icon=ft.icons.ADD, on_click=lambda _: page.go("/articulos")),  # Ir a la página de artículos
        ]
    )


