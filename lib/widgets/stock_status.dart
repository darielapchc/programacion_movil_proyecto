import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StockStatusWidget extends StatelessWidget {
  final int cantidad;
  final int stockMinimo;
  final String titulo;
  const StockStatusWidget({
    super.key,
    required this.cantidad,
    required this.stockMinimo,
    this.titulo = 'Estado del stock',
  });

  @override
  Widget build(BuildContext context) {
    final bool sinStock = cantidad == 0;
    final bool stockBajo = cantidad > 0 && cantidad <= stockMinimo;
    late String mensaje;
    late IconData icono;
    late Color color;

    if (sinStock) {
      mensaje = 'Sin stock';
      icono = Icons.remove_shopping_cart;
      color = AppColors.danger;
    } else if (stockBajo) {
      mensaje = 'Stock bajo';
      icono = Icons.warning_amber_rounded;
      color = AppColors.warning;
    } else {
      mensaje = 'Stock disponible';
      icono = Icons.check_circle;
      color = AppColors.success;
    }

    final double progreso = stockMinimo == 0
        ? 1
        : (cantidad / (stockMinimo * 2)).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          // Estado
          Row(
            children: [
              Icon(
                icono,
                color: color,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mensaje,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Text(
                '$cantidad unidades',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 9,
              // ignore: deprecated_member_use
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stock mínimo: $stockMinimo unidades',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}