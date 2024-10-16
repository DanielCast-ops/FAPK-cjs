import 'package:flutter/material.dart';
import 'package:cjsapp/Modelos/principal.dart';
import 'package:cjsapp/Controladores/base_principal_controlador.dart';

class HistorialInventario extends StatefulWidget {
  const HistorialInventario({super.key});

  @override
  HistorialInventarioState createState() => HistorialInventarioState();
}

class HistorialInventarioState extends State<HistorialInventario> {
  final _formKey = GlobalKey<FormState>();
  
  final cantidadController = TextEditingController();
  final notasController = TextEditingController();
  int? articuloSeleccionado;
  Inventario? transaccionSeleccionada;
  
  List<Articulo> articulos = [];

  @override
  void initState() {
    super.initState();
    cargarArticulos();
  }

  void cargarArticulos() async {
    articulos = await DatabaseController.obtenerTodosLosArticulos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Inventario"),
        backgroundColor: const Color(0xFF316938),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Registro de Movimiento", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: articuloSeleccionado,
                      items: articulos.map((articulo) {
                        return DropdownMenuItem(
                          value: articulo.idArticulo,
                          child: Text(articulo.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          articuloSeleccionado = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Artículo"),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un artículo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: cantidadController,
                      decoration: const InputDecoration(labelText: "Cantidad"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una cantidad';
                        }
                        if (int.tryParse(value) == null || int.parse(value) == 0) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: notasController,
                      decoration: const InputDecoration(labelText: "Notas (opcional)"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: registrarMovimiento,
                          child: const Text("Registrar Movimiento"),
                        ),
                        ElevatedButton(
                          onPressed: transaccionSeleccionada != null ? guardarCambios : null,
                          child: const Text("Guardar Cambios"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Historial de Movimientos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: FutureBuilder<List<Inventario>>(
                  future: DatabaseController.obtenerTodosLosMovimientos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay movimientos registrados"));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final movimiento = snapshot.data![index];
                          return ListTile(
                            title: FutureBuilder<Articulo?>(
                              future: DatabaseController.obtenerArticulo(movimiento.idArticulo),
                              builder: (context, articuloSnapshot) {
                                if (articuloSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Text("Cargando...");
                                } else if (articuloSnapshot.hasError || !articuloSnapshot.hasData) {
                                  return const Text("Error al cargar el artículo");
                                } else {
                                  return Text(articuloSnapshot.data!.nombre);
                                }
                              },
                            ),
                            subtitle: Text("Cantidad: ${movimiento.cantidad}, Fecha: ${movimiento.fecha}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => actualizarMovimiento(movimiento),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => eliminarMovimiento(movimiento.idTransaccion!),
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
        ),
      ),
    );
  }

  void registrarMovimiento() async {
    if (_formKey.currentState!.validate()) {
      final nuevoMovimiento = Inventario(
        idArticulo: articuloSeleccionado!,
        idPersonal: 1, // Asumimos un ID de personal fijo por ahora
        cantidad: int.parse(cantidadController.text),
        fecha: DateTime.now(),
        notas: notasController.text,
      );

      try {
        await DatabaseController.crearTransaccion(nuevoMovimiento);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Movimiento registrado exitosamente.")),
        );
        limpiarFormulario();
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No se pudo registrar el movimiento.")),
        );
      }
    }
  }

  void actualizarMovimiento(Inventario movimiento) {
    setState(() {
      transaccionSeleccionada = movimiento;
      articuloSeleccionado = movimiento.idArticulo;
      cantidadController.text = movimiento.cantidad.toString();
      notasController.text = movimiento.notas ?? "";
    });
  }

  void guardarCambios() async {
    if (_formKey.currentState!.validate() && transaccionSeleccionada != null) {
      final movimientoActualizado = Inventario(
        idTransaccion: transaccionSeleccionada!.idTransaccion,
        idArticulo: articuloSeleccionado!,
        idPersonal: transaccionSeleccionada!.idPersonal,
        cantidad: int.parse(cantidadController.text),
        fecha: transaccionSeleccionada!.fecha,
        notas: notasController.text,
      );

      try {
        await DatabaseController.actualizarTransaccion(movimientoActualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Movimiento actualizado exitosamente.")),
        );
        limpiarFormulario();
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No se pudo actualizar el movimiento.")),
        );
      }
    }
  }

  void eliminarMovimiento(int idTransaccion) async {
    try {
      await DatabaseController.eliminarTransaccion(idTransaccion);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimiento eliminado exitosamente.")),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar el movimiento.")),
      );
    }
  }

  void limpiarFormulario() {
    articuloSeleccionado = null;
    cantidadController.clear();
    notasController.clear();
    transaccionSeleccionada = null;
  }

  @override
  void dispose() {
    cantidadController.dispose();
    notasController.dispose();
    super.dispose();
  }
}