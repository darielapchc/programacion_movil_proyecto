// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../models/movimiento_inventario.dart';
import '../models/producto.dart';
import '../services/movimiento_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  List<Producto> _productos = [];
  List<MovimientoInventario> _movimientos = [];
  bool _cargando = true;
  bool _productosCargados = false;
  bool _movimientosCargados = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) {
      setState(() {
        _cargando = true;
        _error = null;
      });
    }

    String? productosError;
    String? movimientosError;
    List<Producto> productos = [];
    List<MovimientoInventario> movimientos = [];

    try {
      productos = await ProductoService().listarProductos();
    } on ApiException catch (error) {
      productosError = error.message;
    }

    try {
      movimientos = await MovimientoService().listarMovimientos();
    } on ApiException catch (error) {
      movimientosError = error.message;
    }

    if (!mounted) return;
    setState(() {
      _productos = productos;
      _movimientos = movimientos;
      _productosCargados = productosError == null;
      _movimientosCargados = movimientosError == null;
      _error = [productosError, movimientosError]
          .whereType<String>()
          .join('\n');
      _cargando = false;
    });
  }

  String _cantidad(int valor, bool cargado) {
    return cargado ? '$valor' : '—';
  }

  int _movimientosDe(String tipo) {
    return _movimientos
        .where((movimiento) =>
            movimiento.tipoMovimiento.trim().toUpperCase() == tipo.toUpperCase())
        .fold(0, (total, movimiento) => total + movimiento.cantidad);
  }
  @override
  Widget build(BuildContext context) {
    final entradas = _movimientosDe('entrada');
    final salidas = _movimientosDe('salida');
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
            if (_error != null && _error!.isNotEmpty) ...[
              _mensajeError(),
              const SizedBox(height: 16),
            ],

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
                    cantidad: _cargando ? '…' : _cantidad(_productos.length, _productosCargados),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.warning_amber_rounded,
                    titulo: 'Stock bajo',
                    cantidad: _cargando ? '…' : _cantidad(_productos.where((p) => p.stock < 10).length, _productosCargados),
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
                    cantidad: _cargando ? '…' : _cantidad(entradas, _movimientosCargados),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _estadisticaCard(
                    icono: Icons.arrow_upward,
                    titulo: 'Salidas',
                    cantidad: _cargando ? '…' : _cantidad(salidas, _movimientosCargados),
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

            if (_movimientosCargados)
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
                      cantidad: entradas,
                      maximo: entradas == 0 ? 1 : entradas,
                      icono: Icons.arrow_downward,
                    ),

                    const SizedBox(height: 20),

                    _barraMovimiento(
                      titulo: 'Salidas',
                      cantidad: salidas,
                      maximo: salidas == 0 ? 1 : salidas,
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

  Widget _mensajeError() {
    return Card(
      color: AppColors.danger.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger),
            const SizedBox(width: 10),
            Expanded(child: Text(_error!)),
            TextButton(onPressed: _cargar, child: const Text('Reintentar')),
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
              '$cantidad unidades',
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
