import flet as ft
from ACbase_usuario import base_usuario

# Aqui instancio la base de datos, le doy un nombre mas corto para gestionarlo mejor

db = base_usuario()

def Vista_login(page):
    # Creamos los inputs de entrada y les damos visual
    username_input = ft.TextField(label="Nombre de usuario", autofocus=True)
    password_input = ft.TextField(label="Contraseña", password=True, can_reveal_password=True)
    message = ft.Text()

    # Aqui usamos una funcion para el login
    def login_logica(e):
        username = username_input.value
        password = password_input.value

        # aqui se verifican las credenciales con la base de datos
        if db.verificar_login(username, password):
            message.value = "Login exitoso!"
            page.go("/")  # Redirigir a la página principal o home
        else:
            message.value = "Nombre de usuario o contraseña incorrectos."
        page.update()

    return ft.View(
        "/login",
        [
            ft.Text("Iniciar Sesión", size=30),
            username_input,
            password_input,
            ft.ElevatedButton("Login", on_click=handle_login),
            message
        ]
    )

