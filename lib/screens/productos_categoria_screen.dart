import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../models/categorias.dart';
import '../models/producto.dart';
import '../services/favorite_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';
import '../widgets/producto_card.dart';

class ProductosCategoriaScreen extends StatefulWidget {
  final Categorias categoria;

  const ProductosCategoriaScreen({
    super.key,
    required this.categoria,
  });

  @override
  State<ProductosCategoriaScreen> createState() => _ProductosCategoriaScreenState();
}

class _ProductosCategoriaScreenState extends State<ProductosCategoriaScreen> {
  final ProductoService _productoService = ProductoService();
  final FavoriteService _favoriteService = FavoriteService();
  final Set<int> _productosFavoritos = {};

  List<Producto> _productos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final productos = await _productoService.listarProductos();
      Set<int> favoritos = {};
      try {
        favoritos = await _favoriteService.listarIds();
      } on ApiException catch (error) {
        if (mounted) _mostrarError(error.message);
      }
      if (!mounted) return;

      setState(() {
        _productos = productos
            .where((producto) => producto.categoriaId == widget.categoria.id)
            .toList();
        _productosFavoritos
          ..clear()
          ..addAll(favoritos);
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

  Future<void> _verDetalleProducto(Producto producto) async {
    final actualizado = await Navigator.pushNamed(
      context,
      '/detalle',
      arguments: producto,
    );

    if (!mounted || actualizado is! Producto) return;

    setState(() {
      final index = _productos.indexWhere((item) => item.id == actualizado.id);
      if (index != -1 && actualizado.categoriaId == widget.categoria.id) {
        _productos[index] = actualizado;
      }
    });
  }

  Future<void> _alternarFavorito(Producto producto) async {
    final estabaMarcado = _productosFavoritos.contains(producto.id);
    setState(() {
      if (estabaMarcado) {
        _productosFavoritos.remove(producto.id);
      } else {
        _productosFavoritos.add(producto.id);
      }
    });

    try {
      if (estabaMarcado) {
        await _favoriteService.eliminar(producto.id);
      } else {
        await _favoriteService.agregar(producto.id);
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        if (estabaMarcado) {
          _productosFavoritos.add(producto.id);
        } else {
          _productosFavoritos.remove(producto.id);
        }
      });
      _mostrarError(error.message);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.categoria.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            Text(
              'Productos de ${widget.categoria.nombre}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Consulta los productos disponibles en esta categoría.',
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
            const Text(
              'No se pudieron cargar los productos. Intenta nuevamente.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _cargarProductos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_productos.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos en esta categoría.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _productos.length,
      itemBuilder: (context, index) {
        final producto = _productos[index];

        return ProductoCard(
          nombre: producto.nombre,
          codigo: producto.codigo,
          cantidad: producto.stock,
          categoria: producto.categoriaNombre.isEmpty
              ? widget.categoria.nombre
              : producto.categoriaNombre,
          icono: producto.imagen,
          precio: producto.precio,
          esFavorito: _productosFavoritos.contains(producto.id),
          onTap: () => _verDetalleProducto(producto),
          onFavorite: () => _alternarFavorito(producto),
          mostrarEstado: true,
          colorAccento: AppColors.primary,
        );
      },
    );
  }
}
