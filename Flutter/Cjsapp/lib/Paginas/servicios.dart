import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Cjsapp/Modelos/principal.dart';
import 'package:Cjsapp/Controladores/base_principal_controlador.dart';

class AdministracionServicios extends StatefulWidget {
  @override
  _AdministracionServiciosState createState() => _AdministracionServiciosState();
}

class _AdministracionServiciosState extends State<AdministracionServicios> {
  final ServicioController servicioController = ServicioController();
  final EstadoServicioController estadoController = EstadoServicioController();
  
  bool modoEdicion = false;
  Servicio? servicioActual;
  
  final nombreController = TextEditingController();
  final fechaController = TextEditingController();
  final telefonoController = TextEditingController();
  final detallesController = TextEditingController();
  int? estadoSeleccionado;
  
  List<EstadoServicio> estados = [];

  @override
  void initState() {
    super.initState();
    cargarEstados();
    fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void cargarEstados() async {
    estados = await estadoController.obtenerTodosLosEstados();
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
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: "Nombre del Servicio"),
                    ),
                    TextFormField(
                      controller: fechaController,
                      decoration: InputDecoration(labelText: "Fecha (YYYY-MM-DD)"),
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
              future: servicioController.obtenerTodosLosServicios(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No hay servicios registrados");
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
                          subtitle: Text("Fecha: ${servicio.fecha} | Detalles: ${servicio.detalles ?? ''}"),
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
    final nombre = nombreController.text;
    final fecha = fechaController.text;
    final telefonoExtra = telefonoController.text;
    final detalles = detallesController.text;
    final estadoId = estadoSeleccionado!;
    const clienteId = 1; // Valor fijo como en el código original
    const personalId = 1; // Valor fijo como en el código original

    if (modoEdicion && servicioActual != null) {
      final servicioActualizado = servicioActual!.copyWith(
        nombre: nombre,
        fecha: DateTime.parse(fecha),
        telefonoExtra: telefonoExtra,
        detalles: detalles,
        estadoId: estadoId,
        clienteId: clienteId,
        personalId: personalId,
      );
      servicioController.actualizarServicio(servicioActualizado);
    } else {
      final nuevoServicio = Servicio(
        nombre: nombre,
        fecha: DateTime.parse(fecha),
        telefonoExtra: telefonoExtra,
        detalles: detalles,
        estadoId: estadoId,
        clienteId: clienteId,
        personalId: personalId,
      );
      servicioController.crearServicio(nuevoServicio);
    }

    limpiarFormulario();
    setState(() {
      modoEdicion = false;
      servicioActual = null;
    });
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
    });
  }

  void eliminarServicio(int idServicio) {
    servicioController.eliminarServicio(idServicio);
    setState(() {});
  }

  void limpiarFormulario() {
    nombreController.clear();
    fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    telefonoController.clear();
    detallesController.clear();
    estadoSeleccionado = null;
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