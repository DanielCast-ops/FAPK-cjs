#!/usr/bin/env python3

from Controladores_bases.Controlador import Cargo, Cliente, Empleado, Proveedor, EstadoServicio
from Controladores_bases.ACbase_usuario import base_usuario

usrdb = base_usuario()
cjsdb = 'cjs.db'

cargo_controller = Cargo(cjsdb)
cliente_controller = Cliente(cjsdb)
empleado_controller = Empleado(cjsdb)
proveedor_controller = Proveedor(cjsdb)
estado_controller = EstadoServicio(cjsdb)

def inicializar():
    # Cargo
    if not cargo_controller.obtener_cargo(1):
        id_cargo = cargo_controller.crear_cargo('user')
        print(f"Registro creado en 'cargo' con id: {id_cargo}")

    # Cliente
    if not cliente_controller.obtener_cliente(1):
        id_cliente = cliente_controller.crear_cliente('cliente', 'ninguno')
        print(f"Registro creado en 'cliente' con id: {id_cliente}")

    # Empleado
    if not empleado_controller.obtener_empleado(1):
        id_empleado = empleado_controller.crear_empleado('empleado', 1, 'ninguno')
        print(f"Registro creado en 'empleados' con id: {id_empleado}")

    # Estados de Servicio
    estados_default = ['recibido', 'en proceso', 'terminado']
    for i, estado in enumerate(estados_default, start=1):
        if not estado_controller.obtener_estado_servicio(i):
            id_estado = estado_controller.crear_estado_servicio(estado)
            print(f"Registro creado en 'estado_servicio' con id: {id_estado}")

    # Proveedor
    if not proveedor_controller.obtener_proveedor(1):
        id_proveedor = proveedor_controller.crear_proveedor('proveedor', 'ninguno', 'ninguno')
        print(f"Registro creado en 'proveedores' con id: {id_proveedor}")

    # Usuario
    if not usrdb.Consultar_usuario('admin'):
        user = usrdb.registrar_usuario('admin', 'admin')
        print(f"Registro creado en 'usuarios' con user: {user}")

if __name__ == "__main__":
    inicializar()
