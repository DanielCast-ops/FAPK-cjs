#!/usr/bin/env python3

import flet as ft
from Controladores_bases.Controlador import Articulo, Inventario
from flet.plotly_chart import PlotlyChart
import plotly.graph_objects as go

db = 'cjs.db'

def mostrar_inventario(page):
    articulo_controller = Articulo(db)
    inventario_controller = Inventario(db)

    # en esta parte obtengo el inventario
    def obtener_inventario_total():
        articulos = articulo_controller.obtener_todos_los_articulos()
        resumen = []
        for articulo in articulos:
            cantidad_total = inventario_controller.obtener_cantidad_articulo(articulo['id_articulo'])
            resumen.append({
                'nombre': articulo['nombre'],
                'cantidad': cantidad_total,
                'especificacion': articulo['especificacion']
            })
        return resumen

    # aqui se genera la tabla
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

    # En esta parte trabajo los graficos
    def generar_grafico():
        resumen = obtener_inventario_total()
        nombres = [articulo['nombre'] for articulo in resumen]
        cantidades = [articulo['cantidad'] for articulo in resumen]

        fig = go.Figure(data=[go.Bar(x=nombres, y=cantidades)])
        fig.update_layout(title='Cantidad de Artículos por Nombre', xaxis_title='Artículo', yaxis_title='Cantidad')

        return PlotlyChart(fig, expand=True)

    # aqui los botones de navegacion
    boton_principal = ft.ElevatedButton("Página Principal", on_click=lambda _: page.go("/"))
    boton_agregar = ft.IconButton(icon=ft.icons.ADD, on_click=lambda _: page.go("/articulos"))
    boton_historial = ft.IconButton(icon=ft.icons.HISTORY, on_click=lambda _: page.go("/historico"))

    # esta es la tabla de resumen del inventario
    tabla_contenido = ft.DataTable(
        columns=[
            ft.DataColumn(ft.Text("Artículo")),
            ft.DataColumn(ft.Text("Cantidad")),
            ft.DataColumn(ft.Text("Especificación")),
        ],
        rows=generar_tabla_resumen()
    )

    # contenedor
    contenedor_scroll = ft.Column(
        controls=[tabla_contenido],
        height=300,
        scroll="auto"
    )

    # controlador principal
    return ft.Column(
        controls=[
            ft.Row(
                controls=[boton_principal, boton_agregar, boton_historial],
                alignment=ft.MainAxisAlignment.SPACE_BETWEEN
            ),
            generar_grafico(),
            contenedor_scroll
        ]
    )

