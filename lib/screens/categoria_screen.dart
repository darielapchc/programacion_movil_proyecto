import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../models/categorias.dart';
import '../models/producto.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});
  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  List<Categorias> cats = [];
  List<Producto> ps = [];
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
        CategoriaService().listarActivas(),
        ProductoService().listar(),
      ]);
      if (mounted) {
        setState(() {
          cats = r[0] as List<Categorias>;
          ps = r[1] as List<Producto>;
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
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Categorías de productos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        ...cats.map((x) {
          final n = ps.where((p) => p.categoriaId == x.id).length;
          return Card(
            child: ListTile(
              leading: const Icon(Icons.category, color: AppColors.primary),
              title: Text(x.nombre),
              subtitle: Text('$n productos'),
            ),
          );
        }),
      ],
    );
  }
}
