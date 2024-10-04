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

def inicializar():#inicializador, datos base para el funcionamiento de la db
    id_cargo = cargo_controller.crear_cargo('user')
    #print(f"Registro creado en 'cargo' con id: {id_cargo}")

    id_cliente = cliente_controller.crear_cliente('cliente', 'ninguno')
    #print(f"Registro creado en 'cliente' con id: {id_cliente}")

    id_empleado = empleado_controller.crear_empleado('empleado', id_cargo, 'ninguno')
    #print(f"Registro creado en 'empleados' con id: {id_empleado}")

    id_estado_1 = estado_controller.crear_estado_servicio('recibido')
    id_estado_2 = estado_controller.crear_estado_servicio('en proceso')
    id_estado_3 = estado_controller.crear_estado_servicio('terminado')
    #print(f"Registros creados en 'estado_servicio' con ids: {id_estado_1}, {id_estado_2}, {id_estado_3}")

    id_proveedor = proveedor_controller.crear_proveedor('proveedor', 'ninguno', 'ninguno')
    #print(f"Registro creado en 'proveedores' con id: {id_proveedor}")

    user = usrdb.registrar_usuario('admin', 'admin')
    #print(f"Registro creado en 'usuarios' con user: {user}")
