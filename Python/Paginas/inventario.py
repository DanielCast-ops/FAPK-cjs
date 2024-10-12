import flet as ft
from Controladores_bases.Controlador import Articulo, Inventario
import svgwrite #reemplazo el controlador anterior por este que no tiene codigo nativo

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

    def crear_grafico_barras(datos, ancho=600, alto=400):
        if not datos:
            # validacion de datos en blanco
            dwg = svgwrite.Drawing('grafico.svg', size=(ancho, alto))
            dwg.add(dwg.text('No hay datos para mostrar', insert=(ancho/2, alto/2),
                             font_size='20px', text_anchor='middle', fill='#316938'))
            return dwg.tostring()

        dwg = svgwrite.Drawing('grafico.svg', size=(ancho, alto))

        # grafico
        margen = 40
        ancho_grafico = ancho - 2 * margen
        alto_grafico = alto - 2 * margen
        ancho_barra = ancho_grafico / len(datos) * 0.8
        espacio_barra = ancho_grafico / len(datos) * 0.2

        # escalado
        max_valor = max(valor for _, valor in datos)

        #  eje Y
        dwg.add(dwg.line(start=(margen, margen), end=(margen, alto - margen), stroke='#316938'))

        #  eje X
        dwg.add(dwg.line(start=(margen, alto - margen), end=(ancho - margen, alto - margen), stroke='#316938'))

        #  barras y etiquetas
        for i, (nombre, valor) in enumerate(datos):
            # Calcular las dimensiones de la barra
            x = margen + i * (ancho_barra + espacio_barra)
            y = alto - margen - (valor / max_valor * alto_grafico) if max_valor > 0 else alto - margen
            altura_barra = alto - margen - y

            # barra
            dwg.add(dwg.rect(insert=(x, y), size=(ancho_barra, altura_barra), fill='#316938'))

            # etiqueta del eje X (nombre del artículo)
            dwg.add(dwg.text(nombre, insert=(x + ancho_barra/2, alto - margen + 20),
                             font_size='12px', text_anchor='middle', fill='#316938'))

            # etiqueta de valor
            dwg.add(dwg.text(str(valor), insert=(x + ancho_barra/2, y - 5),
                             font_size='12px', text_anchor='middle', fill='#316938'))

        # título
        dwg.add(dwg.text('Cantidad de Artículos por Nombre', insert=(ancho/2, 20),
                         font_size='16px', text_anchor='middle', fill='#316938', font_weight='bold'))

        return dwg.tostring()

    def generar_grafico():
        resumen = obtener_inventario_total()
        datos = [(articulo['nombre'], articulo['cantidad']) for articulo in resumen]
        svg_string = crear_grafico_barras(datos)

        return ft.Image(
            src=f"data:image/svg+xml,{svg_string}",
            width=600,
            height=400,
            fit=ft.ImageFit.CONTAIN
        )
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

    contenido_principal = ft.Column([
        ft.Text("Resumen de Inventario", size=20, weight=ft.FontWeight.BOLD, color="#316938"),
        generar_grafico(),
        tabla_contenido
    ])

    return ft.View(
        "/inventario",
        [
            ft.AppBar(
                title=ft.Text("Inventario", color="white"),
                bgcolor="#316938",
                actions=[icono_home, icono_agregar, icono_historial]
            ),
            ft.Container(
                content=ft.ListView(
                    [contenido_principal],
                    expand=True,
                    spacing=20,
                    padding=20,
                ),
                expand=True,
            ),
        ],
        bgcolor="#F0F0F0"
    )
