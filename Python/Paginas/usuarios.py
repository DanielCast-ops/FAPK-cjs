import flet as ft
from Controladores_bases.ACbase_usuario import base_usuario

db = base_usuario()

def mostrar_usuarios(page):
    user_list = ft.ListView(expand=1, spacing=10, padding=20)
    username_input = ft.TextField(label="Nombre de usuario", border_color="#316938")
    password_input = ft.TextField(label="Contraseña", password=True, can_reveal_password=True, border_color="#316938")
    message = ft.Text(color="#316938")

    usuario_actual = None

    def cargar_usuarios():
        user_list.controls.clear()
        usuarios = db.listar_usuarios()
        for usuario in usuarios:
            user_list.controls.append(
                ft.Container(
                    ft.Row(
                        [
                            ft.Text(f"ID: {usuario[0]}", color="#316938"),
                            ft.Text(f"Nombre: {usuario[1]}", color="#316938"),
                            ft.IconButton(ft.icons.EDIT, icon_color="#316938", on_click=lambda e, usuario=usuario: editar_usuario(usuario)),
                            ft.IconButton(ft.icons.DELETE, icon_color="#316938", on_click=lambda e, usuario=usuario: borrar_usuario(usuario[1]))
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_BETWEEN
                    ),
                    bgcolor="#F0F0F0",
                    border_radius=10,
                    padding=10
                )
            )
        page.update()

    def agregar_usuario(e):
        username = username_input.value
        password = password_input.value
        if db.registrar_usuario(username, password):
            message.value = "Usuario registrado exitosamente."
            cargar_usuarios()
        else:
            message.value = "Error: El nombre de usuario ya existe."
        username_input.value = ""
        password_input.value = ""
        page.update()

    def editar_usuario(user):
        nonlocal usuario_actual
        usuario_actual = user
        username_input.value = user[1]
        password_input.value = ""
        boton.text = "Actualizar usuario"
        boton.on_click = actualizar_usuario
        page.update()

    def actualizar_usuario(e):
        nonlocal usuario_actual
        new_password = password_input.value
        if usuario_actual and db.actualizar_usuario(usuario_actual[1], new_password):
            message.value = "Usuario actualizado exitosamente."
        else:
            message.value = "Error al actualizar el usuario."
        username_input.value = ""
        password_input.value = ""
        usuario_actual = None
        boton.text = "Agregar usuario"
        boton.on_click = agregar_usuario
        cargar_usuarios()
        page.update()

    def borrar_usuario(username):
        if db.eliminar_usuario(username):
            message.value = "Usuario eliminado exitosamente."
        else:
            message.value = "Error al eliminar el usuario."
        cargar_usuarios()
        page.update()


    boton = ft.ElevatedButton(
        "Agregar usuario",
        on_click = agregar_usuario,
        style=ft.ButtonStyle(color="white", bgcolor="#316938")
    )

    cargar_usuarios()

    return ft.View(
        "/users",
        [
            ft.AppBar(
                title=ft.Text("Administración de Usuarios", color="white"),
                bgcolor="#316938",
                center_title=True
            ),
            ft.Container(
                content=ft.Column([
                    user_list,
                    ft.Divider(color="#316938"),
                    ft.Text("Agregar/Editar Usuario:", size=20, color="#316938", weight=ft.FontWeight.BOLD),
                    username_input,
                    password_input,
                    ft.Row(
                        [boton],
                        alignment=ft.MainAxisAlignment.START,
                    ),
                    message,
                    ft.ElevatedButton(
                        "Regresar",
                        on_click=lambda _: page.go("/home"),
                        style=ft.ButtonStyle(color="white", bgcolor="#316938")
                    ),
                ], spacing=20),
                padding=20,
                bgcolor="#F0F0F0",
                expand=True
            )
        ],
        bgcolor="#F0F0F0"
    )
