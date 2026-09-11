import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_config.dart';
import '../models/producto.dart';
import '../models/movimiento_inventario.dart';
import '../services/producto_service.dart';
import '../services/movimiento_service.dart';
import '../utils/app_colors.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});
  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  List<Producto> ps = [];
  List<MovimientoInventario> ms = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await Future.wait([
        ProductoService().listar(),
        MovimientoService().listar(),
      ]);
      if (mounted) {
        setState(() {
          ps = r[0] as List<Producto>;
          ms = r[1] as List<MovimientoInventario>;
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
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) return Scaffold(body: Center(child: Text(error!)));
    final en = ms.where((x) => x.tipoMovimiento == 'ENTRADA').length;
    final sa = ms.where((x) => x.tipoMovimiento == 'SALIDA').length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _i('Productos', ps.length.toString()),
          _i(
            'Stock bajo',
            ps
                .where((x) => x.stock < ApiConfig.lowStockThreshold)
                .length
                .toString(),
          ),
          _i('Entradas', en.toString()),
          _i('Salidas', sa.toString()),
        ],
      ),
    );
  }

  Widget _i(String a, String b) => Card(
    child: ListTile(
      title: Text(a),
      trailing: Text(
        b,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    ),
  );
}
