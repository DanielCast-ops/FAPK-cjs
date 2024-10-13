import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage ({super.key});

  Widget _buildNavigationCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF316938)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF316938),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [
      _buildNavigationCard(context, "Inventario", Icons.inventory, "/inventario"),
      _buildNavigationCard(context, "Servicios", Icons.miscellaneous_services, "/servicios"),
      _buildNavigationCard(context, "Usuarios", Icons.people, "/usuarios"),
      // _buildNavigationCard(context, "Reportes", Icons.bar_chart, "/reportes"), // Para futuro uso
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF316938),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings, color: Colors.white),
        //     onPressed: () => Navigator.pushNamed(context, "/configuracion"),
        //   ),
        // ], // Para futuro uso
      ),
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text(
                  "Panel de Control",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF316938),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: cards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}