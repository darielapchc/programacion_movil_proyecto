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
    return SafeArea(
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
              "LNE Stock",
              style: TextStyle(
                fontSize: 18,
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

                  MenuCard(
                    titulo: "Reportes",
                    icono: Icons.bar_chart,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Disponible próximamente"),
                        ),
                      );
                    },
                  ),

                ],

              ),
            ),

          ],
        ),
      ),
    );
  }
}