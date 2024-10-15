import 'package:flutter/material.dart';
import 'package:Cjsapp/Modelos/principal.dart';
import 'package:Cjsapp/Controladores/base_principal_controlador.dart';

class GestionEstadosServicios extends StatefulWidget {
  const GestionEstadosServicios({super.key});

  @override
  _GestionEstadosServiciosState createState() => _GestionEstadosServiciosState();
}

class _GestionEstadosServiciosState extends State<GestionEstadosServicios> {
  EstadoServicio? estadoSeleccionado;
  TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Estados de Servicios"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: "Descripción del Estado"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: agregarEstado,
                child: const Text("Agregar Estado"),
              ),
              ElevatedButton(
                onPressed: estadoSeleccionado != null ? guardarCambios : null,
                child: const Text("Guardar Cambios"),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<EstadoServicio>>(
              future: DatabaseController.obtenerTodosLosEstados(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay estados registrados"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final estado = snapshot.data![index];
                      return ListTile(
                        title: Text(estado.descripcion),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => editarEstado(estado),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => eliminarEstado(estado.idEstado!),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void agregarEstado() async {
    if (descripcionController.text.isNotEmpty) {
      final nuevoEstado = EstadoServicio(descripcion: descripcionController.text);
      await DatabaseController.crearEstadoServicio(nuevoEstado);
      descripcionController.clear();
      setState(() {});
    }
  }

  void editarEstado(EstadoServicio estado) {
    setState(() {
      estadoSeleccionado = estado;
      descripcionController.text = estado.descripcion;
    });
  }

  void guardarCambios() async {
    if (estadoSeleccionado != null && descripcionController.text.isNotEmpty) {
      final estadoActualizado = estadoSeleccionado!.copyWith(descripcion: descripcionController.text);
      await DatabaseController.actualizarEstadoServicio(estadoActualizado);
      limpiarFormulario();
      setState(() {});
    }
  }

  void eliminarEstado(int idEstado) async {
    await DatabaseController.eliminarEstadoServicio(idEstado);
    setState(() {});
  }

  void limpiarFormulario() {
    setState(() {
      estadoSeleccionado = null;
      descripcionController.clear();
    });
  }
}