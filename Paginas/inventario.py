import flet as ft
from Controladores_bases.Controlador import Articulo, Inventario
from flet.plotly_chart import PlotlyChart
import plotly.graph_objects as go

db = 'cjs.db'

def mostrar_inventario(page):
    articulo_controller = Articulo(db)
    inventario_controller = Inventario(db)

    def obtener_inventario_total():
        articulos = articulo_controller.obtener_todos_los_articulos()
        resumen = []
        for articulo in articulos:
            cantidad_total = inventario_controller.obtener_cantidad_articulo(articulo['nombre'])
            resumen.append({
                'nombre': articulo['nombre'],
                'cantidad': cantidad_total,
                'especificacion': articulo['especificacion']
            })
        return resumen

    def generar_tabla_resumen():
        filas = []
        resumen = obtener_inventario_total()
        for articulo in resumen:
            fila = ft.DataRow(
                cells=[
                    ft.DataCell(ft.Text(articulo["nombre"])),
                    ft.DataCell(ft.Text(str(articulo["cantidad"]))),
                    ft.DataCell(ft.Text(articulo["especificacion"]))
                ]
            )
            filas.append(fila)
        return filas

    def generar_grafico():
        resumen = obtener_inventario_total()
        nombres = [articulo['nombre'] for articulo in resumen]
        cantidades = [articulo['cantidad'] for articulo in resumen]

        fig = go.Figure(data=[go.Bar(x=nombres, y=cantidades, marker_color='#316938')])
        fig.update_layout(
            title='Cantidad de Artículos por Nombre',
            xaxis_title='Artículo',
            yaxis_title='Cantidad',
            plot_bgcolor='rgba(0,0,0,0)',
            paper_bgcolor='rgba(0,0,0,0)',
            font=dict(color='#316938')
        )

        return PlotlyChart(fig, expand=True)

    def ir_a_home(e):
        page.go("/home")

    def ir_a_articulos(e):
        page.go("/articulos")

    def ir_a_historial(e):
        page.go("/historial")

    icono_home = ft.IconButton(
        icon=ft.icons.HOME,
        tooltip="Inicio",
        icon_color="white",
        on_click=ir_a_home
    )

    icono_agregar = ft.IconButton(
        icon=ft.icons.ADD,
        tooltip="Agregar Artículo",
        icon_color="white",
        on_click=ir_a_articulos
    )

    icono_historial = ft.IconButton(
        icon=ft.icons.HISTORY,
        tooltip="Historial",
        icon_color="white",
        on_click=ir_a_historial
    )

    tabla_contenido = ft.DataTable(
        columns=[
            ft.DataColumn(ft.Text("Artículo", color="#316938")),
            ft.DataColumn(ft.Text("Cantidad", color="#316938")),
            ft.DataColumn(ft.Text("Especificación", color="#316938")),
        ],
        rows=generar_tabla_resumen(),
        border=ft.border.all(1, "#316938"),
        border_radius=10,
        vertical_lines=ft.border.BorderSide(1, "#316938"),
        horizontal_lines=ft.border.BorderSide(1, "#316938"),
    )

    contenedor_scroll = ft.Container(
        content=tabla_contenido,
        height=300,
        border=ft.border.all(1, "#316938"),
        border_radius=10,
        padding=10,
    )

    return ft.View(
        "/inventario",
        [
            ft.AppBar(
                title=ft.Text("Inventario", color="white"),
                bgcolor="#316938",
                actions=[icono_home, icono_agregar, icono_historial]
            ),
            ft.Container(
                content=ft.Column([
                    ft.Text("Resumen de Inventario", size=20, weight=ft.FontWeight.BOLD, color="#316938"),
                    generar_grafico(),
                    contenedor_scroll
                ]),
                padding=20,
            ),
        ],
        bgcolor="#F0F0F0"
    )
