import flet as ft
from Controladores_bases.ACbase_usuario import base_usuario

db = base_usuario()

def Vista_login(page):
    def login_logica(e):
        username = username_input.value
        password = password_input.value

        if db.verificar_login(username, password):
            message.value = "Login exitoso!"
            message.color = ft.colors.GREEN
            page.go("/home")
        else:
            message.value = "Nombre de usuario o contraseña incorrectos."
            message.color = ft.colors.RED
        page.update()

    logo = ft.Image(
        src="./assets/icon.png",
        width=150,
        height=150,
        fit=ft.ImageFit.CONTAIN,
    )

    username_input = ft.TextField(
        label="Nombre de usuario",
        border_color="#316938",
        focused_border_color="#316938",
        autofocus=True
    )

    password_input = ft.TextField(
        label="Contraseña",
        password=True,
        can_reveal_password=True,
        border_color="#316938",
        focused_border_color="#316938"
    )

    message = ft.Text(color="#316938")

    login_button = ft.ElevatedButton(
        "Iniciar Sesión",
        on_click=login_logica,
        style=ft.ButtonStyle(
            color="white",
            bgcolor="#316938",
            padding=15,
        )
    )

    login_card = ft.Container(
        content=ft.Column([
            logo,
            ft.Text("Iniciar Sesión", size=28, weight=ft.FontWeight.BOLD, color="#316938"),
            username_input,
            password_input,
            login_button,
            message
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=20
        ),
        width=400,
        padding=30,
        bgcolor=ft.colors.WHITE,
        border_radius=20,
        shadow=ft.BoxShadow(
            spread_radius=1,
            blur_radius=5,
            color=ft.colors.BLACK12,
            offset=ft.Offset(0, 2),
        )
    )

    return ft.View(
        "/login",
        [
            ft.Container(
                content=login_card,
                expand=True,
                alignment=ft.alignment.center,
            )
        ],
        bgcolor="#F0F0F0",
        padding=0
    )
