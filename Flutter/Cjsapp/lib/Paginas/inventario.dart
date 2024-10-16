import 'package:flutter/material.dart';
import 'package:cjsapp/Modelos/principal.dart';
import 'package:cjsapp/Controladores/base_principal_controlador.dart';
import 'package:fl_chart/fl_chart.dart';

class Inventario extends StatefulWidget {
  @override
  _InventarioState createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  List<ResumenInventario> resumenInventario = [];

  @override
  void initState() {
    super.initState();
    cargarResumenInventario();
  }

  void cargarResumenInventario() async {
    List<Articulo> articulos = await DatabaseController.obtenerTodosLosArticulos();
    resumenInventario = await Future.wait(articulos.map((articulo) async {
      int cantidad = await DatabaseController.obtenerCantidadArticulo(articulo.idArticulo!);
      return ResumenInventario(
        nombre: articulo.nombre,
        cantidad: cantidad,
        especificacion: articulo.especificacion,
      );
    }));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventario"),
        backgroundColor: Color(0xFF316938),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/articulos'),
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/historial'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Resumen de Inventario", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF316938))),
              SizedBox(height: 20),
              Container(
                height: 300,
                child: resumenInventario.isNotEmpty
                    ? BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: resumenInventario.map((e) => e.cantidad.toDouble()).reduce((a, b) => a > b ? a : b),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitles: (value) {
                                int index = value.toInt();
                                return index < resumenInventario.length ? resumenInventario[index].nombre : '';
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitles: (value) {
                                return value.toString();
                              },
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: resumenInventario.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  y: entry.value.cantidad.toDouble(),
                                  colors: [Color(0xFF316938)],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    : Center(child: Text("No hay datos para mostrar")),
              ),
              SizedBox(height: 20),
              DataTable(
                columns: [
                  DataColumn(label: Text('Artículo', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF316938)))),
                  DataColumn(label: Text('Cantidad', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF316938)))),
                  DataColumn(label: Text('Especificación', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF316938)))),
                ],
                rows: resumenInventario.map((item) => DataRow(
                  cells: [
                    DataCell(Text(item.nombre)),
                    DataCell(Text(item.cantidad.toString())),
                    DataCell(Text(item.especificacion)),
                  ],
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResumenInventario {
  final String nombre;
  final int cantidad;
  final String especificacion;

  ResumenInventario({required this.nombre, required this.cantidad, required this.especificacion});
}
