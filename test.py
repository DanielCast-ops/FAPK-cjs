#!/usr/bin/env python3

#!/usr/bin/env python3

from Controladores_bases.Controlador import Articulo

# Función para probar obtener_articulo()
def probar_obtener_articulo(db, id_articulo):
    # Instanciar el controlador de Articulos
    articulo_controller = Articulo(db)

    # Llamar a la función obtener_articulo y mostrar el resultado
    articulo = articulo_controller.obtener_articulo(id_articulo)

    if articulo:
        print(f"Artículo obtenido: ID: {articulo['id_articulo']}, Nombre: {articulo['nombre']}, Especificación: {articulo['especificacion']}, ID Proveedor: {articulo['id_proveedor']}")
    else:
        print(f"No se encontró ningún artículo con el ID: {id_articulo}")

# Ejecutar el script de prueba
if __name__ == "__main__":
    # Asegúrate de pasar correctamente tu conexión a la base de datos  # Modifica este import según tu estructura de proyecto
    db = 'cjs.db'  # Cambia esto por la ubicación real de tu BD

    # Define un ID de artículo para probar
    id_articulo_a_probar = 1  # Cambia esto por el ID del artículo que quieras probar

    probar_obtener_articulo(db, id_articulo_a_probar)

