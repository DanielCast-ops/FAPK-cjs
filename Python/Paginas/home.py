import flet as ft

def mostrar_home(page):
    def navegar(ruta):
        def navegacion(e):
            page.go(ruta)
        return navegacion

    def crear_tarjeta_navegacion(titulo, icono, ruta):
        return ft.Container(
            content=ft.Column([
                ft.Icon(icono, size=48, color="#316938"),
                ft.Text(titulo, size=16, weight=ft.FontWeight.BOLD, color="#316938")
            ], alignment=ft.MainAxisAlignment.CENTER, spacing=10),
            width=150,
            height=150,
            bgcolor=ft.colors.WHITE,
            border_radius=20,
            ink=True,
            on_click=navegar(ruta),
            alignment=ft.alignment.center,
            shadow=ft.BoxShadow(
                spread_radius=1,
                blur_radius=5,
                color=ft.colors.BLACK12,
                offset=ft.Offset(0, 2),
            )
        )

    tarjetas = [
        crear_tarjeta_navegacion("Inventario", ft.icons.INVENTORY, "/inventario"),
        crear_tarjeta_navegacion("Servicios", ft.icons.MISCELLANEOUS_SERVICES, "/servicios"),
        crear_tarjeta_navegacion("Usuarios", ft.icons.PEOPLE, "/usuarios"),
        #crear_tarjeta_navegacion("Reportes", ft.icons.BAR_CHART, "/reportes") se deja la posibilidad de esta otra pagina para el futuro
    ]

    grid_view = ft.GridView(
        expand=1,
        runs_count=2,
        max_extent=200,
        child_aspect_ratio=1.0,
        spacing=20,
        run_spacing=20,
    )

    for tarjeta in tarjetas:
        grid_view.controls.append(tarjeta)

    contenido_principal = ft.Column([
        ft.Container(
            content=ft.Text("Panel de Control", size=28, weight=ft.FontWeight.BOLD, color="#316938"),
            margin=ft.margin.only(top=20, bottom=10)
        ),
        ft.Container(
            content=grid_view,
            expand=True
        )
    ], alignment=ft.MainAxisAlignment.START, spacing=10)

    return ft.View(
        "/home",
        [
            ft.AppBar(
                title=ft.Text("Inicio", color="white", size=20),
                bgcolor="#316938",
                center_title=True,
                #actions=[
                #    ft.IconButton(ft.icons.SETTINGS, icon_color="white", on_click=navegar("/configuracion"))
                #] se deja esta funcion tambien para un futuro
            ),
            ft.Container(
                content=contenido_principal,
                expand=True,
                alignment=ft.alignment.top_center,
                padding=10
            )
        ],
        bgcolor="#F0F0F0",
        padding=0
    )
