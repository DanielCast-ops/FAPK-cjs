import 'package:flutter/material.dart';
import 'package:cjsapp/Paginas/articulos.dart';
import 'package:cjsapp/Paginas/historial.dart';
import 'package:cjsapp/Paginas/login.dart';
import 'package:cjsapp/Paginas/servicios.dart';
import 'package:cjsapp/Paginas/estado_servicios.dart';
import 'package:cjsapp/Paginas/home.dart';
import 'package:cjsapp/Paginas/inventario.dart';
import 'package:cjsapp/Paginas/usuarios.dart';
import 'package:cjsapp/Controladores/inicializador.dart';


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
        '/articulos': (context) => const AdministracionArticulos(),
        '/historial': (context) => const HistorialInventario(),
        '/servicios': (context) => const AdministracionServicios(),
        '/estado_servicios': (context) => const GestionEstadosServicios(),
        '/inventario': (context) => Inventario(),
        '/usuarios': (context) => const UsersPage(),
      },
    );
  }
}