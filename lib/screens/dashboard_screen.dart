import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_config.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigate;
  const DashboardScreen({super.key, this.onNavigate});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Producto> products = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await ProductoService().listar();
      if (mounted) {
        setState(() {
          products = p;
          loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          error = e.message;
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext c) {
    final low = products
        .where((p) => p.stock < ApiConfig.lowStockThreshold)
        .length;
    final total = products.fold<int>(0, (s, p) => s + p.stock);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '¡Hola!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const Text('Bienvenida a LNE Stock', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 25),
          const Text(
            'Resumen del inventario',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Text(error!)
              : Row(
                  children: [
                    Expanded(
                      child: _card(
                        'Productos',
                        '${products.length}',
                        Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _card('Stock bajo', '$low', Icons.warning_amber),
                    ),
                  ],
                ),
          const SizedBox(height: 15),
          _card('Stock total', '$total unidades', Icons.stacked_bar_chart),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => widget.onNavigate?.call(1),
            icon: const Icon(Icons.inventory),
            label: const Text('Ver inventario'),
          ),
        ],
      ),
    );
  }

  Widget _card(String t, String v, IconData i) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Icon(i, color: AppColors.primary, size: 30),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t),
              Text(
                v,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
