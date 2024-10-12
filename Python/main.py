#!/usr/bin/env python3

import flet as ft
from Paginas import login, usuarios, historial, articulos, inventario, servicios, estado_servicios, home
from Controladores_bases.Cbase_principal import crear_base
from Controladores_bases.inicializador import inicializar

def main(page: ft.Page):
    page.title = "Gestión de la Aplicación"
    page.theme_mode = ft.ThemeMode.LIGHT
    crear_base('cjs.db')
    inicializar()
    # Aqui pongo una funcion para manejar la navegación entre páginas
    def route_change(route):
        page.views.clear()
        if page.route == "/":
            page.views.append(home.home_view(page))
        elif page.route == "/usuarios":
            page.views.append(usuarios.mostrar_usuarios(page))
        elif page.route == "/historial":
            page.views.append(historial.mostrar_inventario(page, "cjs.db"))
        elif page.route == "/inventario":
            page.views.append(inventario.mostrar_inventario(page))
        elif page.route == "/articulos":
            page.views.append(articulos.registrar_articulo(page))
        elif page.route == "/servicios":
            page.views.append(servicios.administracion_servicios(page))
        elif page.route == "/estado_servicios":
            page.views.append(estado_servicios.gestion_estados_servicios(page))
        elif page.route == "/login":
            page.views.append(login.Vista_login(page))  # Página de login
        elif page.route == "/home":
            page.views.append(home.mostrar_home(page))
        page.update()

    # y aqui una función para regresar a la página anterior
    def go_back(e):
        if len(page.views) > 1:
            page.views.pop()
            top_view = page.views[-1]
            page.go(top_view.route)

    page.on_route_change = route_change
    page.on_view_pop = go_back

    #  inicial como el login
    page.go("/login")

# Correr la app
ft.app(target=main)

