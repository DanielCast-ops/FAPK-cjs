import flet as ft
from Controladores_bases.Controlador import Articulo

# aqui nombro la base de datos
db = 'cjs.db'

#funcion de registrar
def registrar_articulo(page):
    articulo_controller = Articulo(db)

    # Campos del forulario
    nombre_input = ft.TextField(label="Nombre del Artículo")
    especificacion_input = ft.TextField(label="Especificación")
    proveedor_input = ft.TextField(label="ID del Proveedor")
    message = ft.Text()

    # funcion para agregar un artículo
    def agregar_articulo(e):
        nombre = nombre_input.value
        especificacion = especificacion_input.value
        id_proveedor = proveedor_input.value

        if articulo_controller.crear_articulo(nombre, especificacion, id_proveedor):
            message.value = "Artículo registrado exitosamente."
            nombre_input.value = ""
            especificacion_input.value = ""
            proveedor_input.value = ""
            actualizar_tabla()  # actualiza la tabla después de registrar un nuevo artículo
        else:
            message.value = "Error: No se pudo registrar el artículo."
        page.update()

    # aqui pongo la funcion para obtener todos los artículos
    def obtener_articulos():
        return articulo_controller.obtener_todos_los_articulos()

    # aqui la funcion para generar la tabla de artículos
    def generar_tabla_articulos():
        filas = []
        articulos = obtener_articulos()
        #print(f"articulos obtenidos: {articulos}")
        for articulo in articulos:
            fila = ft.DataRow(
                cells=[
                    ft.DataCell(ft.Text(articulo['nombre'])),
                    ft.DataCell(ft.Text(articulo['especificacion'])),
                    ft.DataCell(ft.IconButton(icon=ft.icons.DELETE, on_click=lambda e, id_articulo=articulo["id_articulo"]:eliminar_articulo(id_articulo)))
                ]
            )
            filas.append(fila)
        return filas

    def eliminar_articulo(id_articulo):
        try:
             articulo_controller.eliminar_articulo(id_articulo)
             # print(f"Transacción {id_transaccion} eliminada con éxito.")
             actualizar_tabla()
        except Exception as ex:
             print(f"Error al eliminar el articulo: {ex}")

    # aqui la de actualizar la tabla
    def actualizar_tabla():
        tabla_contenido.rows = generar_tabla_articulos()
        page.update()

    # boton de registro
    registrar_button = ft.ElevatedButton("Registrar Artículo", on_click=agregar_articulo)

    # aqui la tabla
    tabla_contenido = ft.DataTable(
        columns=[
            ft.DataColumn(ft.Text("Nombre")),
            ft.DataColumn(ft.Text("Especificación")),
            ft.DataColumn(ft.Text("Eliminar")),
        ],
        rows=generar_tabla_articulos()  # Llena
    )

    contenedor_scroll = ft.Column(
        controls=[tabla_contenido],
        height=300,  # altura
        scroll="auto"  # scroll
    )

    # distribucion principal de la página de artículos
    return ft.View(
        "/registrar_articulo",
        [
            ft.Text("Registro de Artículo", size=30),
            nombre_input,
            especificacion_input,
            proveedor_input,
            registrar_button,
            message,
            ft.Text("Lista de Artículos Registrados", size=20),
            contenedor_scroll,  # Agregar la tabla con scroll
            ft.ElevatedButton("Regresar", on_click=lambda _: page.go("/inventario")),
        ]
    )

