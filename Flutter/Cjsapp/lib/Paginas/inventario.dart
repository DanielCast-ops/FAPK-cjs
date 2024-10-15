import 'package:flutter/material.dart';
import 'package:Cjsapp/Modelos/principal.dart';
import 'package:Cjsapp/Controladores/base_principal_controlador.dart';
import 'package:fl_chart/fl_chart.dart';

class Inventario extends StatefulWidget {
  const Inventario({super.key});

  @override
  InventarioState createState() => InventarioState();
}

class InventarioState extends State<Inventario> {
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
        title: const Text("Inventario"),
        backgroundColor: const Color(0xFF316938),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/articulos'),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/historial'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Resumen de Inventario", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF316938))),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: resumenInventario.isNotEmpty
                    ? BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: resumenInventario.map((e) => e.cantidad.toDouble()).reduce((a, b) => a > b ? a : b),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    resumenInventario[value.toInt()].nombre,
                                    style: const TextStyle(color: Color(0xFF316938), fontWeight: FontWeight.bold, fontSize: 14),
                                  ); 
                                },
                                reservedSize: 40,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: resumenInventario.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.cantidad.toDouble(), 
                                  color: const Color(0xFF316938), 
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    : const Center(child: Text("No hay datos para mostrar")),
              ),
              const SizedBox(height: 20),
              DataTable(
                columns: const [
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