import 'package:flutter/material.dart';
//import 'package:Cjsapp/Paginas/articulos.dart';
//import 'package:Cjsapp/Paginas/historial.dart';
import 'package:Cjsapp/Paginas/login.dart';
import 'package:Cjsapp/Paginas/servicios.dart';
import 'package:Cjsapp/Paginas/estado_servicios.dart';
import 'package:Cjsapp/Paginas/home.dart';
//import 'package:Cjsapp/Paginas/inventario.dart';
import 'package:Cjsapp/Paginas/usuarios.dart';
import 'package:Cjsapp/Controladores/inicializador.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Inicializacion.inicializar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CjsApp',
      theme: ThemeData(
        primaryColor: const Color(0xFF316938),
        colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF316938),
      secondary: const Color(0xFF316938),
    ),
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF316938),
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF316938)),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        //'/articulos': (context) => ArticulosPage(),
        //'/historial': (context) => HistorialPage(),
        '/servicios': (context) => AdministracionServicios(),
        '/estado_servicios': (context) => GestionEstadosServicios(),
        //'/inventario': (context) => InventarioPage(),
        '/usuarios': (context) => const UsersPage(),
      },
    );
  }
}