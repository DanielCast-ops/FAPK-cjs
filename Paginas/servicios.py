import flet as ft
from Controladores_bases.Controlador import Servicio, EstadoServicio

db = 'cjs.db'
servicio_controller = Servicio(db)
estado_controller = EstadoServicio(db)

# Página de administración de servicios
def administracion_servicios(page):
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

    lista_servicios = ft.Column([], scroll=ft.ScrollMode.AUTO, expand=True)

    def actualizar_lista():
        lista_servicios.controls = mostrar_historial_servicios()
        page.update()

    # Inputs para crear/editar servicios
    nombre_input = ft.TextField(label="Nombre del Servicio", expand=True)
    fecha_input = ft.TextField(label="Fecha (YYYY-MM-DD)", expand=True)
    telefono_input = ft.TextField(label="Teléfono Extra", expand=True)
    detalles_input = ft.TextField(label="Detalles del Servicio", expand=True)
    estado_id_input = ft.TextField(label="ID del Estado", expand=True)
    #cliente_id_input = ft.TextField(label="ID del Cliente", expand=True)
    #personal_id_input = ft.TextField(label="ID del Personal", expand=True)
    message = ft.Text()

    def agregar_servicio(e):
        nombre = nombre_input.value
        fecha = fecha_input.value
        telefono_extra = telefono_input.value
        detalles = detalles_input.value
        estado_id = estado_id_input.value
        cliente_id = '1'
        personal_id = '1'

        if servicio_controller.crear_servicio(nombre, fecha, telefono_extra, detalles, estado_id, cliente_id, personal_id):
            message.value = "Servicio creado exitosamente."
            nombre_input.value = ""
            fecha_input.value = ""
            telefono_input.value = ""
            detalles_input.value = ""
            estado_id_input.value = ""
            #cliente_id_input.value = ""
            #personal_id_input.value = ""
            actualizar_lista()
        else:
            message.value = "Error al crear el servicio."
        page.update()

    def editar_servicio(id_servicio):
        servicio = servicio_controller.obtener_servicio(id_servicio)
        if servicio:
            nombre_input.value = servicio['nombre']
            fecha_input.value = servicio['fecha']
            telefono_input.value = servicio['telefono_extra']
            detalles_input.value = servicio['detalles']
            estado_id_input.value = servicio['estado_id']
            #cliente_id_input.value = servicio['cliente_id']
            #personal_id_input.value = servicio['personal_id']
        page.update()

    def eliminar_servicio(id_servicio):
        servicio_controller.eliminar_servicio(id_servicio)
        message.value = "Servicio eliminado."
        actualizar_lista()

    vista = ft.View(
        "/administrar_servicios",
        [
            ft.AppBar(title=ft.Text("Administración de Servicios"), bgcolor=ft.colors.BLUE),
            ft.Container(
                content=ft.Column([
                    ft.Text("Agregar Nuevo Servicio", size=20, weight=ft.FontWeight.BOLD),
                    ft.Row([nombre_input, fecha_input, telefono_input], expand=True),
                    ft.Row([detalles_input, estado_id_input], expand=True),
                    ft.ElevatedButton("Agregar Servicio", on_click=agregar_servicio, icon=ft.icons.ADD),
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

