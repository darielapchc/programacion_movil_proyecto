// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../models/movimiento_inventario.dart';
import '../models/producto.dart';
import '../services/movimiento_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';

class MovimientosScreen extends StatefulWidget {
  const MovimientosScreen({super.key});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  final _movimientoService = MovimientoService();
  final _productoService = ProductoService();
  List<MovimientoInventario> _movimientos = [];
  List<Producto> _productos = [];
  bool _cargando = true;
  bool _esAdmin = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final role = await ApiClient.instance.storage.getRole();
      if (mounted) setState(() => _esAdmin = role?.toLowerCase() == 'admin');
      final resultados = await Future.wait([
        _movimientoService.listarMovimientos(),
        _productoService.listarProductos(),
      ]);
      if (!mounted) return;
      setState(() {
        _movimientos = resultados[0] as List<MovimientoInventario>;
        _productos = resultados[1] as List<Producto>;
        _cargando = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar la información del inventario.';
        _cargando = false;
      });
    }
  }

  Future<void> _mostrarFormulario(String tipo) async {
    if (_productos.isEmpty) {
      _mostrarMensaje('No hay productos disponibles para registrar movimientos.');
      return;
    }

    final resultado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _FormularioMovimiento(
        tipo: tipo,
        productos: _productos,
        registrar: (cantidad, productoId) => _movimientoService.registrarMovimiento(
          tipoMovimiento: tipo,
          cantidad: cantidad,
          productoId: productoId,
        ),
      ),
    );

    if (resultado == true && mounted) {
      _mostrarMensaje(
        tipo == 'ENTRADA'
            ? 'Entrada registrada correctamente.'
            : 'Salida registrada correctamente.',
      );
      await _cargarDatos();
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Producto? _productoPara(MovimientoInventario movimiento) {
    if (movimiento.producto != null) return movimiento.producto;
    for (final producto in _productos) {
      if (producto.id == movimiento.productoId) return producto;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Movimientos de inventario'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _cargando ? null : _cargarDatos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: _contenido(),
      ),
    );
  }

  Widget _contenido() {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * .22),
          _EstadoMensaje(icono: Icons.cloud_off, mensaje: _error!, accion: _cargarDatos),
        ],
      );
    }
    if (_movimientos.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (_productos.isNotEmpty) ...[
            _accionesMovimiento(),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 110),
          _EstadoMensaje(
            icono: Icons.swap_vert,
            mensaje: 'Todavía no hay movimientos registrados.',
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _movimientos.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        if (index == 0) return _accionesMovimiento();
        final movimiento = _movimientos[index - 1];
        final entrada = movimiento.tipoMovimiento.toUpperCase() == 'ENTRADA';
        final producto = _productoPara(movimiento);
        final usuario = movimiento.usuario?.fullName;
        return Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: (entrada ? AppColors.success : AppColors.warning)
                  .withOpacity(.14),
              child: Icon(
                entrada ? Icons.south_west : Icons.north_east,
                color: entrada ? AppColors.success : AppColors.warning,
              ),
            ),
            title: Text(
              entrada ? 'Entrada' : 'Salida',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text([
                producto?.nombre ?? 'Producto #${movimiento.productoId}',
                if (producto != null && producto.codigo.isNotEmpty) 'Código: ${producto.codigo}',
                _formatearFecha(movimiento.fecha),
                if (usuario != null && usuario.isNotEmpty) 'Usuario: $usuario',
              ].join(' · ')),
            ),
            trailing: Text(
              '${entrada ? '+' : '-'}${movimiento.cantidad}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: entrada ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _accionesMovimiento() {
    if (!_esAdmin) return const SizedBox.shrink();
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) => Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            spacing: 8,
            children: [
              SizedBox(
                width: constraints.maxWidth > 460 ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth,
                child: FilledButton.icon(
                  onPressed: () => _mostrarFormulario('ENTRADA'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                  icon: const Icon(Icons.south_west),
                  label: const Text('Registrar entrada'),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth > 460 ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth,
                child: OutlinedButton.icon(
                  onPressed: () => _mostrarFormulario('SALIDA'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary),
                  icon: const Icon(Icons.north_east),
                  label: const Text('Registrar salida'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearFecha(String fecha) {
    final parsed = DateTime.tryParse(fecha);
    if (parsed == null) return fecha.isEmpty ? 'Fecha no disponible' : fecha;
    final local = parsed.toLocal();
    String dos(int valor) => valor.toString().padLeft(2, '0');
    return '${dos(local.day)}/${dos(local.month)}/${local.year} ${dos(local.hour)}:${dos(local.minute)}';
  }
}

class _FormularioMovimiento extends StatefulWidget {
  final String tipo;
  final List<Producto> productos;
  final Future<MovimientoInventario> Function(int cantidad, int productoId) registrar;

  const _FormularioMovimiento({
    required this.tipo,
    required this.productos,
    required this.registrar,
  });

  @override
  State<_FormularioMovimiento> createState() => _FormularioMovimientoState();
}

class _FormularioMovimientoState extends State<_FormularioMovimiento> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  int? _productoId;
  bool _enviando = false;
  String? _error;

  bool get _esEntrada => widget.tipo == 'ENTRADA';
  Producto? get _productoSeleccionado => _productoId == null
      ? null
      : widget.productos.firstWhere((producto) => producto.id == _productoId);

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final cantidad = int.tryParse(_cantidadController.text.trim());
    final producto = _productoSeleccionado;
    if (producto == null || cantidad == null || cantidad <= 0) return;
    if (!_esEntrada && cantidad > producto.stock) {
      setState(() => _error = 'No hay suficiente stock disponible.');
      return;
    }

    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      await widget.registrar(cantidad, producto.id);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = _mensajeError(error.message);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = 'No se pudo registrar el movimiento.';
      });
    }
  }

  String _mensajeError(String mensaje) {
    final normalizado = mensaje.toLowerCase();
    if (normalizado.contains('stock') || normalizado.contains('suficiente')) {
      return 'No hay suficiente stock disponible.';
    }
    if (normalizado.contains('permiso') || normalizado.contains('403')) {
      return 'No tienes permisos para registrar movimientos.';
    }
    if (normalizado.contains('conectar') || normalizado.contains('servidor')) {
      return mensaje;
    }
    return mensaje;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 18),
                Text(
                  _esEntrada ? 'Registrar entrada' : 'Registrar salida',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<int>(
                  initialValue: _productoId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  items: widget.productos.map((producto) => DropdownMenuItem<int>(
                    value: producto.id,
                    child: Text('${producto.nombre} · ${producto.codigo} · Stock: ${producto.stock}', overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: _enviando ? null : (valor) => setState(() { _productoId = valor; _error = null; }),
                  validator: (valor) => valor == null ? 'Debes seleccionar un producto.' : null,
                ),
                if (_productoSeleccionado != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Stock actual: ${_productoSeleccionado!.stock}',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text),
                  ),
                ],
                const SizedBox(height: 14),
                TextFormField(
                  controller: _cantidadController,
                  enabled: !_enviando,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _esEntrada ? 'Cantidad a ingresar' : 'Cantidad a retirar',
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (valor) {
                    final cantidad = int.tryParse(valor?.trim() ?? '');
                    if (cantidad == null || cantidad <= 0) return 'La cantidad debe ser mayor que 0.';
                    if (!_esEntrada && _productoSeleccionado != null && cantidad > _productoSeleccionado!.stock) return 'No hay suficiente stock disponible.';
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.danger), textAlign: TextAlign.center),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _enviando ? null : _enviar,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                  icon: _enviando ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(_esEntrada ? Icons.add : Icons.remove),
                  label: Text(_enviando ? 'Guardando...' : 'Confirmar ${_esEntrada ? 'entrada' : 'salida'}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoMensaje extends StatelessWidget {
  final IconData icono;
  final String mensaje;
  final VoidCallback? accion;

  const _EstadoMensaje({required this.icono, required this.mensaje, this.accion});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 52, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.text)),
            if (accion != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: accion, child: const Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}
