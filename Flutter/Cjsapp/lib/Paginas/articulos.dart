import 'package:flutter/material.dart';
import 'package:Cjsapp/Modelos/principal.dart';
import 'package:Cjsapp/Controladores/base_principal_controlador.dart';

class AdministracionArticulos extends StatefulWidget {
  @override
  _AdministracionArticulosState createState() => _AdministracionArticulosState();
}

class _AdministracionArticulosState extends State<AdministracionArticulos> {
  final _formKey = GlobalKey<FormState>();
  
  final nombreController = TextEditingController();
  final especificacionController = TextEditingController();
  int? proveedorSeleccionado;
  
  List<Proveedor> proveedores = [];

  @override
  void initState() {
    super.initState();
    cargarProveedores();
  }

  void cargarProveedores() async {
    proveedores = await DatabaseController.obtenerTodosLosProveedores();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administración de Artículos"),
        backgroundColor: Color(0xFF316938),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Registro de Artículo", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: "Nombre del Artículo"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: especificacionController,
                      decoration: InputDecoration(labelText: "Especificación"),
                    ),
                    DropdownButtonFormField<int>(
                      value: proveedorSeleccionado,
                      items: proveedores.map((proveedor) {
                        return DropdownMenuItem(
                          value: proveedor.idProveedor,
                          child: Text(proveedor.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          proveedorSeleccionado = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "Proveedor"),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un proveedor';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text("Registrar Artículo"),
                      onPressed: agregarArticulo,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text("Lista de Artículos Registrados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: FutureBuilder<List<Articulo>>(
                  future: DatabaseController.obtenerTodosLosArticulos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No hay artículos registrados"));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final articulo = snapshot.data![index];
                          return ListTile(
                            title: Text(articulo.nombre),
                            subtitle: Text(articulo.especificacion),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => eliminarArticulo(articulo.idArticulo!),
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

  void agregarArticulo() async {
    if (_formKey.currentState!.validate()) {
      final nuevoArticulo = Articulo(
        nombre: nombreController.text,
        especificacion: especificacionController.text,
        idProveedor: proveedorSeleccionado!,
      );

      try {
        await DatabaseController.crearArticulo(nuevoArticulo);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Artículo registrado exitosamente.")),
        );
        nombreController.clear();
        especificacionController.clear();
        proveedorSeleccionado = null;
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: No se pudo registrar el artículo.")),
        );
      }
    }
  }

  void eliminarArticulo(int idArticulo) async {
    try {
      await DatabaseController.eliminarArticulo(idArticulo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Artículo eliminado exitosamente.")),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar el artículo.")),
      );
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    especificacionController.dispose();
    super.dispose();
  }
}