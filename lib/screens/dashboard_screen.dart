import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) cambiarPagina;

  const DashboardScreen({
    super.key,
    required this.cambiarPagina,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text("LNE Stock"),
        backgroundColor: const Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "👋 Bienvenido",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Librería y Novedades Emanuel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    MenuCard(
                      titulo: "Inventario",
                      icono: Icons.inventory_2,
                      onTap: () => cambiarPagina(1),
                    ),
                    MenuCard(
                      titulo: "Categorías",
                      icono: Icons.category,
                      onTap: () => cambiarPagina(2),
                    ),
                    MenuCard(
                      titulo: "Agregar",
                      icono: Icons.add_box,
                      onTap: () => cambiarPagina(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}