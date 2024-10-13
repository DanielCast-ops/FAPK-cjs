import 'package:flutter/material.dart';
//import 'package:Cjsapp/Paginas/articulos.dart';
//import 'package:Cjsapp/Paginas/historial.dart';
import 'package:Cjsapp/Paginas/login.dart';
//import 'package:Cjsapp/Paginas/servicios.dart';
//import 'package:Cjsapp/Paginas/estado_servicios.dart';
//import 'package:Cjsapp/Paginas/home.dart';
//import 'package:Cjsapp/Paginas/inventario.dart';
import 'package:Cjsapp/Paginas/usuarios.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CjsApp',
      theme: ThemeData(
        primaryColor: Color(0xFF316938),
        accentColor: Color(0xFF316938),
        scaffoldBackgroundColor: Color(0xFFF0F0F0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF316938),
            onPrimary: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF316938)),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        //'/home': (context) => HomePage(),
        //'/articulos': (context) => ArticulosPage(),
        //'/historial': (context) => HistorialPage(),
        //'/servicios': (context) => ServiciosPage(),
        //'/estado_servicios': (context) => EstadoServiciosPage(),
        //'/inventario': (context) => InventarioPage(),
        '/usuarios': (context) => UsersPage(),
      },
    );
  }
}