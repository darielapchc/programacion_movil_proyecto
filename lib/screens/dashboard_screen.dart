import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/menu_card.dart';
import '../widgets/stock_status.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const DashboardScreen({
    super.key,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double ancho = constraints.maxWidth;

          // Márgenes adaptables
          final double paddingHorizontal =
              ancho < 500 ? 16 : ancho < 900 ? 24 : 32;

          // Espaciado adaptable
          final double espacio =
              ancho < 500 ? 12 : ancho < 900 ? 16 : 20;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola!',
                            style: TextStyle(
                              fontSize: ancho < 500 ? 28 : 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Bienvenida a LNE Stock',
                            style: TextStyle(
                              fontSize: ancho < 500 ? 17 : 20,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Perfil
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: ancho < 500 ? 28 : 32,
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
                const SizedBox(height: 30),
                Text(
                  'Resumen del inventario',
                  style: TextStyle(
                    fontSize: ancho < 500 ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _estadisticaCard(
                        icono: Icons.inventory_2,
                        titulo: 'Productos',
                        cantidad: '125',
                      ),
                    ),

                    SizedBox(width: espacio),

                    Expanded(
                      child: _estadisticaCard(
                        icono: Icons.warning_amber_rounded,
                        titulo: 'Stock bajo',
                        cantidad: '8',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const StockStatusWidget(
                  cantidad: 8,
                  stockMinimo: 10,
                  titulo: 'Resumen del stock',
                ),
                const SizedBox(height: 30),
                Text(
                  'Accesos rápidos',
                  style: TextStyle(
                    fontSize: ancho < 500 ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: _obtenerColumnas(ancho),
                  crossAxisSpacing: espacio,
                  mainAxisSpacing: espacio,
                  childAspectRatio: _obtenerAspectRatio(ancho),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // INVENTARIO
                    MenuCard(
                      titulo: 'Inventario',
                      icono: Icons.inventory_2,
                      onTap: () {
                        // Utilizamos la navegación principal
                        // en lugar de pushNamed('/inventario').
                        onNavigate?.call(1);
                      },
                    ),

                    // CATEGORÍAS
                    MenuCard(
                      titulo: 'Categorías',
                      icono: Icons.category,
                      onTap: () {
                        onNavigate?.call(2);
                      },
                    ),

                    // AGREGAR
                    MenuCard(
                      titulo: 'Agregar',
                      icono: Icons.add_box,
                      onTap: () {
                        onNavigate?.call(3);
                      },
                    ),

                    // ESTADÍSTICAS
                    MenuCard(
                      titulo: 'Estadísticas',
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
          );
        },
      ),
    );
  }

  
  int _obtenerColumnas(double ancho) {
    if (ancho >= 1000) {
      return 4;
    }

    if (ancho >= 700) {
      return 3;
    }

    return 2;
  }
  double _obtenerAspectRatio(double ancho) {
    if (ancho >= 1000) {
      return 1.35;
    }

    if (ancho >= 700) {
      return 1.25;
    }

    return 1.05;
  }

  Widget _estadisticaCard({
    required IconData icono,
    required String titulo,
    required String cantidad,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
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
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                cantidad,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}