import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/storage_service.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});
  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final q = TextEditingController();
  List<Producto> ps = [];
  Usuario? u;
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await ProductoService().listar();
      u = await StorageService().getUser();
      if (mounted) {
        setState(() {
          ps = r;
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
  void dispose() {
    q.dispose();
    super.dispose();
  }

  Future<void> _delete(Producto p) async {
    try {
      await ProductoService().eliminar(p.id);
      if (mounted) setState(() => ps.removeWhere((x) => x.id == p.id));
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext c) {
    final s = q.text.toLowerCase();
    final list = ps
        .where(
          (p) =>
              p.nombre.toLowerCase().contains(s) ||
              p.codigo.toLowerCase().contains(s) ||
              p.categoriaNombre.toLowerCase().contains(s),
        )
        .toList();
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: q,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Buscar producto',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No hay productos registrados.'))
                : ListView(
                    children: list
                        .map(
                          (p) => Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.inventory_2,
                                color: AppColors.primary,
                              ),
                              title: Text(p.nombre),
                              subtitle: Text(
                                '${p.categoriaNombre} | Stock: ${p.stock}',
                              ),
                              onTap: () => Navigator.pushNamed(
                                c,
                                '/detalle',
                                arguments: p,
                              ),
                              trailing: u?.role == 'admin'
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _delete(p),
                                    )
                                  : null,
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
