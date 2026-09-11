import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../utils/app_colors.dart';

class DetalleProductoScreen extends StatelessWidget {
  const DetalleProductoScreen({super.key});
  @override
  Widget build(BuildContext c) {
    final p = ModalRoute.of(c)?.settings.arguments as Producto?;
    if (p == null) {
      return const Scaffold(
        body: Center(child: Text('Producto no disponible')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de producto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.inventory_2, size: 100, color: AppColors.primary),
          Text(
            p.nombre,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          Text(
            p.categoriaNombre,
            style: const TextStyle(color: AppColors.primary),
          ),
          Card(
            child: Column(
              children: [
                _r('Código', p.codigo),
                _r('Categoría', p.categoriaNombre),
                _r('Precio', 'L. ${p.precio.toStringAsFixed(2)}'),
                _r('Cantidad disponible', '${p.stock} unidades'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _r(String a, String b) => ListTile(title: Text(a), trailing: Text(b));
}
