import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/menu_card.dart';
import '../widgets/stock_status.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    final int columnas = ancho > 600 ? 3 : 2;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // ENCABEZADO
            // ==========================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
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
                      Navigator.pushNamed(context, '/perfil');
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ==========================================================
            // RESUMEN DEL INVENTARIO
            // ==========================================================
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

            // Estado del stock
            const StockStatusWidget(
              cantidad: 8,
              stockMinimo: 10,
              titulo: 'Resumen del stock',
            ),

            const SizedBox(height: 30),

            // ==========================================================
            // ACCESOS RÁPIDOS
            // ==========================================================
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
              crossAxisCount: columnas,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Inventario
                MenuCard(
                  titulo: "Inventario",
                  icono: Icons.inventory_2,
                  onTap: () {
                    Navigator.pushNamed(context, '/inventario');
                  },
                ),

                // Categorías
                MenuCard(
                  titulo: "Categorías",
                  icono: Icons.category,
                  onTap: () {
                    Navigator.pushNamed(context, '/categorias');
                  },
                ),

                // Agregar producto
                MenuCard(
                  titulo: "Agregar",
                  icono: Icons.add_box,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/agregar-producto',
                    );
                  },
                ),

                // Estadísticas
                MenuCard(
                  titulo: "Estadísticas",
                  icono: Icons.bar_chart,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/estadisticas',
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

  // ==========================================================
  // WIDGET PARA LAS ESTADÍSTICAS
  // ==========================================================
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
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.12),
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