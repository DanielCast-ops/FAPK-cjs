import flet as ft
from Controladores_bases.ACbase_usuario import base_usuario

# Aqui se instancia la base de datos
db = base_usuario()

def mostrar_usuarios(page):
    # Aqui se definen los componentes iniciales
    user_list = ft.ListView(expand=True, spacing=10)
    username_input = ft.TextField(label="Nombre de usuario")
    password_input = ft.TextField(label="Contraseña", password=True, can_reveal_password=True)
    message = ft.Text()

    # Aqui cargamos la base de datos
    def cargar_usuarios():
        user_list.controls.clear()
        usuarios = db.listar_usuarios()  # Aqui se obtienen los usuarios de la base de datos
        for usuario in usuarios:
            # Aqui la funcion para que muestre la opcion de eliminar el usuario o borrarlo
            user_list.controls.append(
                ft.Row(
                    [
                        ft.Text(f"ID: {usuario[0]}"),
                        ft.Text(f"Nombre: {usuario[1]}"),
                        ft.IconButton(ft.icons.EDIT, on_click=lambda e, usuario=usuario: editar_usuario(usuario)),
                        ft.IconButton(ft.icons.DELETE, on_click=lambda e, usuario=usuario: borrar_usuario(usuario[1]))
                    ]
                )
            )
        page.update()

    # Aqui pongo la funcion para crear un nuevo usuario
    def agregar_usuario(e):
        username = username_input.value
        password = password_input.value
        if db.registrar_usuario(username, password):
            message.value = "Usuario registrado exitosamente."
            cargar_usuarios()  # Recargar la lista de usuarios
        else:
            message.value = "Error: El nombre de usuario ya existe."
        username_input.value = ""
        password_input.value = ""
        page.update()

    # Aqui la funcion para editar el usuario
    def editar_usuario(user):
        username_input.value = user[1]  # Rellenar el campo con el nombre de usuario existente
        password_input.value = ""

        # Aqui para actualizar el password
        def actualizar_usuario(e):
            new_password = password_input.value
            if db.actualizar_usuario(user[1], new_password):
                message.value = "Usuario actualizado exitosamente."
            else:
                message.value = "Error al actualizar el usuario."
            username_input.value = ""
            password_input.value = ""
            cargar_usuarios()  # Recargar la lista de usuarios
            page.update()

            # Verificar que page.controls tiene al menos dos elementos y que el penúltimo elemento tiene al menos dos subcontroles
        if len(page.controls) >= 2 and len(page.controls[-2].controls) > 1:
            page.controls[-2].controls[1] = ft.ElevatedButton("Actualizar Usuario", actualizar_usuario)
        else:
             # Si no hay suficientes elementos, añade el botón de actualización en un nuevo lugar adecuado
            if len(page.controls) > 1:
                page.controls[-1] = ft.ElevatedButton("Actualizar Usuario", actualizar_usuario)
            else:
                 # en esta parte valida si no hay suficientes controles, añade el botón de actualización en un nuevo Row
                page.controls.append(ft.Row([ft.ElevatedButton("Actualizar Usuario", actualizar_usuario)]))
            page.update()

    # En esta parte esta la funcion para borrar el usuario
    def borrar_usuario(username):
        if db.eliminar_usuario(username):
            message.value = "Usuario eliminado exitosamente."
        else:
            message.value = "Error al eliminar el usuario."
        cargar_usuarios()  # Recargar la lista de usuarios
        page.update()

    # Cargar usuarios cuando se abre la página
    cargar_usuarios()

    return ft.View(
        "/users",
        [
            ft.Text("Administración de Usuarios", size=30),
            user_list,  # Aquí se mostrará la lista de usuarios
            ft.Text("Agregar/Editar Usuario:", size=20),
            username_input,
            password_input,
            ft.Row(
                [
                    ft.ElevatedButton("Agregar usuario", on_click=agregar_usuario),  # Botón para agregar usuario
                ],
                alignment=ft.MainAxisAlignment.START,
            ),
            message,  # Mostrar mensajes de éxito o error
            ft.ElevatedButton("Regresar", on_click=lambda _: page.go("/")),  # Botón para volver a la página principal
        ]
    )
