import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Estadísticas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Resumen del inventario',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Consulta rápidamente el estado de tu inventario.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),

            const SizedBox(height: 20),

            // PRIMERA FILA
            Row(
              children: [

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.inventory_2,
                    titulo: 'Productos',
                    cantidad: '125',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.warning_amber_rounded,
                    titulo: 'Stock bajo',
                    cantidad: '8',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // SEGUNDA FILA
            Row(
              children: [

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.arrow_downward,
                    titulo: 'Entradas',
                    cantidad: '35',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.arrow_upward,
                    titulo: 'Salidas',
                    cantidad: '18',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Movimiento de inventario',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    _barraMovimiento(
                      titulo: 'Entradas',
                      cantidad: 35,
                      maximo: 40,
                      icono: Icons.arrow_downward,
                    ),

                    const SizedBox(height: 20),

                    _barraMovimiento(
                      titulo: 'Salidas',
                      cantidad: 18,
                      maximo: 40,
                      icono: Icons.arrow_upward,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          AppColors.primary.withOpacity(0.12),
                      child: const Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Text(
                        'Las estadísticas permiten conocer '
                        'rápidamente el estado actual del inventario.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  AppColors.primary.withOpacity(0.12),
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

            const SizedBox(height: 4),

            Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraMovimiento({
    required String titulo,
    required int cantidad,
    required int maximo,
    required IconData icono,
  }) {
    double porcentaje = cantidad / maximo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              children: [
                Icon(
                  icono,
                  color: AppColors.primary,
                ),

                const SizedBox(width: 8),

                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),

            Text(
              '$cantidad movimientos',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: porcentaje,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}