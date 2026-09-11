// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../models/categorias.dart';
import '../services/categoria_service.dart';
import '../utils/app_colors.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final CategoriaService _service = CategoriaService();

  List<Categorias> _categorias = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final result = await _service.listarCategorias();
      if (!mounted) return;

      setState(() {
        _categorias = result;
        _cargando = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.message;
        _cargando = false;
      });
    }
  }

  IconData _icono(String valor) {
    switch (valor.toLowerCase()) {
      case 'menu_book':
        return Icons.menu_book;
      case 'edit':
        return Icons.edit;
      case 'description':
        return Icons.description;
      case 'palette':
        return Icons.palette;
      case 'business_center':
        return Icons.business_center;
      case 'school':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Categorías',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categorías de productos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Organiza los productos de la librería.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _construirContenido()),
          ],
        ),
      ),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _cargarCategorias,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_categorias.isEmpty) {
      return const Center(child: Text('No hay categorías registradas.'));
    }

    return ListView.builder(
      itemCount: _categorias.length,
      itemBuilder: (context, index) {
        final categoria = _categorias[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Icon(
                _icono(categoria.icono),
                color: AppColors.primary,
                size: 28,
              ),
            ),
            title: Text(
              categoria.nombre,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            subtitle: Text(
              categoria.descripcion.isEmpty
                  ? 'Categoría activa'
                  : categoria.descripcion,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 17,
              color: AppColors.primary,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionaste ${categoria.nombre}')),
              );
            },
          ),
        );
      },
    );
  }
}
