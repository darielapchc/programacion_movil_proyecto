import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/menu_card.dart';
import 'perfil_screen.dart';
import 'estadisticas_screen.dart';
import '../widgets/stock_status.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) cambiarPagina;

  const DashboardScreen({
    super.key,
    required this.cambiarPagina,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "¡Hola!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Bienvenida a LNE Stock",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

                // Botón de perfil
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (_) => const PerfilScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Título
            const Text(
              "Resumen del inventario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 15),

            // Estadísticas
            Row(
              children: [

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.inventory_2,
                    titulo: "Productos",
                    cantidad: "125",
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.warning_amber_rounded,
                    titulo: "Stock bajo",
                    cantidad: "8",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const StockStatusWidget(
              cantidad: 8,
              stockMinimo: 10,
              titulo: 'Resumen del stock',
            ),

            const SizedBox(height: 30),
            

            const Text(
              "Accesos rápidos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 15),

            // Cards principales
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                  titulo: "Estadísticas",
                  icono: Icons.bar_chart,
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (_) => const EstadisticasScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para las estadísticas
  Widget _estadisticaCard({
    required IconData icono,
    required String titulo,
    required String cantidad,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CircleAvatar(
              // ignore: deprecated_member_use
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Icon(
                icono,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              cantidad,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 3),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}