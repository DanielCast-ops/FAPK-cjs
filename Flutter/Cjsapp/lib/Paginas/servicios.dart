import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Cjsapp/Modelos/principal.dart';
import 'package:Cjsapp/Controladores/base_principal_controlador.dart';

class AdministracionServicios extends StatefulWidget {
  @override
  _AdministracionServiciosState createState() => _AdministracionServiciosState();
}

class _AdministracionServiciosState extends State<AdministracionServicios> {
  final _formKey = GlobalKey<FormState>();
  bool modoEdicion = false;
  Servicio? servicioActual;
  
  final nombreController = TextEditingController();
  final fechaController = TextEditingController();
  final telefonoController = TextEditingController();
  final detallesController = TextEditingController();
  int? estadoSeleccionado;
  int? clienteSeleccionado;
  int? empleadoSeleccionado;
  
  List<EstadoServicio> estados = [];
  List<Cliente> clientes = [];
  List<Empleado> empleados = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
    fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void cargarDatos() async {
    estados = await DatabaseController.obtenerTodosLosEstados();
    clientes = await DatabaseController.obtenerTodosLosClientes();
    empleados = await DatabaseController.obtenerTodosLosEmpleados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administración de Servicios"),
        backgroundColor: Color(0xFF316938),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/estado_servicios'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: "Nombre del Servicio"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: fechaController,
                      decoration: InputDecoration(labelText: "Fecha (YYYY-MM-DD)"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una fecha';
                        }
                        // Add date format validation if needed
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: telefonoController,
                      decoration: InputDecoration(labelText: "Teléfono Extra"),
                    ),
                    TextFormField(
                      controller: detallesController,
                      decoration: InputDecoration(labelText: "Detalles del Servicio"),
                    ),
                    DropdownButtonFormField<int>(
                      value: estadoSeleccionado,
                      items: estados.map((estado) {
                        return DropdownMenuItem(
                          value: estado.idEstado,
                          child: Text(estado.descripcion),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          estadoSeleccionado = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "Estado del Servicio"),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un estado';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: clienteSeleccionado,
                      items: clientes.map((cliente) {
                        return DropdownMenuItem(
                          value: cliente.idCliente,
                          child: Text(cliente.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          clienteSeleccionado = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "Cliente"),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un cliente';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: empleadoSeleccionado,
                      items: empleados.map((empleado) {
                        return DropdownMenuItem(
                          value: empleado.idPersonal,
                          child: Text(empleado.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          empleadoSeleccionado = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "Empleado"),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un empleado';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(modoEdicion ? "Actualizar Servicio" : "Agregar Servicio"),
                      onPressed: guardarOActualizarServicio,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Text("Servicios Registrados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            FutureBuilder<List<Servicio>>(
              future: DatabaseController.obtenerTodosLosServicios(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No hay servicios registrados"));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final servicio = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(servicio.nombre),
                          subtitle: Text("Fecha: ${DateFormat('yyyy-MM-dd').format(servicio.fecha)} | Detalles: ${servicio.detalles ?? ''}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => editarServicio(servicio),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => eliminarServicio(servicio.idServicio!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void guardarOActualizarServicio() {
    if (_formKey.currentState!.validate()) {
      final nombre = nombreController.text;
      final fecha = DateTime.parse(fechaController.text);
      final telefonoExtra = telefonoController.text;
      final detalles = detallesController.text;

      if (modoEdicion && servicioActual != null) {
        final servicioActualizado = servicioActual!.copyWith(
          nombre: nombre,
          fecha: fecha,
          telefonoExtra: telefonoExtra,
          detalles: detalles,
          estadoId: estadoSeleccionado!,
          clienteId: clienteSeleccionado!,
          personalId: empleadoSeleccionado!,
        );
        DatabaseController.actualizarServicio(servicioActualizado);
      } else {
        final nuevoServicio = Servicio(
          nombre: nombre,
          fecha: fecha,
          telefonoExtra: telefonoExtra,
          detalles: detalles,
          estadoId: estadoSeleccionado!,
          clienteId: clienteSeleccionado!,
          personalId: empleadoSeleccionado!,
        );
        DatabaseController.crearServicio(nuevoServicio);
      }

      limpiarFormulario();
      setState(() {
        modoEdicion = false;
        servicioActual = null;
      });
    }
  }

  void editarServicio(Servicio servicio) {
    setState(() {
      modoEdicion = true;
      servicioActual = servicio;
      nombreController.text = servicio.nombre;
      fechaController.text = DateFormat('yyyy-MM-dd').format(servicio.fecha);
      telefonoController.text = servicio.telefonoExtra ?? '';
      detallesController.text = servicio.detalles ?? '';
      estadoSeleccionado = servicio.estadoId;
      clienteSeleccionado = servicio.clienteId;
      empleadoSeleccionado = servicio.personalId;
    });
  }

  void eliminarServicio(int idServicio) async {
    await DatabaseController.eliminarServicio(idServicio);
    setState(() {});
  }

  void limpiarFormulario() {
    nombreController.clear();
    fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    telefonoController.clear();
    detallesController.clear();
    estadoSeleccionado = null;
    clienteSeleccionado = null;
    empleadoSeleccionado = null;
  }

  @override
  void dispose() {
    nombreController.dispose();
    fechaController.dispose();
    telefonoController.dispose();
    detallesController.dispose();
    super.dispose();
  }
}