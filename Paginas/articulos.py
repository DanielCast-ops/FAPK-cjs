import flet as ft
from Controladores_bases.Controlador import Articulo

# Instancia de la base de datos
db = 'cjs.db'  # Instancia base de datos

def registrar_articulo(page):
    nombre_input = ft.TextField(label="Nombre del Artículo")
    especificacion_input = ft.TextField(label="Especificación")
    proveedor_input = ft.TextField(label="ID del Proveedor")
    message = ft.Text()

    def agregar_articulo(e):
        nombre = nombre_input.value
        especificacion = especificacion_input.value
        id_proveedor = proveedor_input.value

        articulo_controller = Articulo(db)

        if articulo_controller.crear_articulo(nombre, especificacion, id_proveedor):
            message.value = "Artículo registrado exitosamente."
            nombre_input.value = ""
            especificacion_input.value = ""
            proveedor_input.value = ""
        else:
            message.value = "Error: No se pudo registrar el artículo."
        page.update()

    registrar_button = ft.ElevatedButton("Registrar Artículo", on_click=agregar_articulo)

    return ft.View(
        "/registrar_articulo",
        [
            ft.Text("Registro de Artículo", size=30),
            nombre_input,
            especificacion_input,
            proveedor_input,
            registrar_button,
            message,
            ft.ElevatedButton("Regresar", on_click=lambda _: page.go("/inventario")),
        ]
    )

