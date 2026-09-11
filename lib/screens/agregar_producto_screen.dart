import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../core/storage_service.dart';
import '../models/categorias.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final form = GlobalKey<FormState>();
  final n = TextEditingController();
  final d = TextEditingController();
  final c = TextEditingController();
  final p = TextEditingController();
  final s = TextEditingController();

  List<Categorias> cats = [];
  int? cat;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      if ((await StorageService().getUser())?.role == 'admin') {
        cats = await CategoriaService().listarActivas();
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    n.dispose();
    d.dispose();
    c.dispose();
    p.dispose();
    s.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!form.currentState!.validate() || cat == null) {
      return;
    }

    setState(() => saving = true);

    try {
      await ProductoService().crear({
        'nombre': n.text,
        'descripcion': d.text,
        'codigo': c.text,
        'precio': double.parse(p.text),
        'stock': int.parse(s.text),
        'imagen': null,
        'categoriaId': cat,
      });

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext x) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: form,
          child: Column(
            children: [
              CampoTexto(
                label: 'Nombre',
                icono: Icons.inventory,
                controlador: n,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 12),
              CampoTexto(
                label: 'Descripción',
                icono: Icons.description,
                controlador: d,
              ),
              const SizedBox(height: 12),
              CampoTexto(
                label: 'Código',
                icono: Icons.qr_code,
                controlador: c,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el código' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: cat,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: cats
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.id, child: Text(e.nombre)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => cat = v),
                validator: (v) => v == null ? 'Seleccione una categoría' : null,
              ),
              const SizedBox(height: 12),
              CampoTexto(
                label: 'Precio',
                icono: Icons.attach_money,
                controlador: p,
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Precio inválido' : null,
              ),
              const SizedBox(height: 12),
              CampoTexto(
                label: 'Stock',
                icono: Icons.numbers,
                controlador: s,
                validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Stock inválido' : null,
              ),
              const SizedBox(height: 20),
              saving
                  ? const CircularProgressIndicator()
                  : BotonPrincipal(texto: 'Guardar Producto', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
