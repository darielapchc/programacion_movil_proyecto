import 'producto.dart';
import 'usuario.dart';

class MovimientoInventario {
  final int id;
  final String tipoMovimiento;
  final int cantidad;
  final String fecha;
  final int productoId;
  final int usuarioId;
  final Producto? producto;
  final Usuario? usuario;

  const MovimientoInventario({
    required this.id,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fecha,
    required this.productoId,
    required this.usuarioId,
    this.producto,
    this.usuario,
  });

  factory MovimientoInventario.fromJson(Map<String, dynamic> json) {
    final rawProducto = json['producto'];
    final rawUsuario = json['usuario'];

    return MovimientoInventario(
      id: _toInt(json['id'] ?? json['idMovimiento']),
      tipoMovimiento: '${json['tipoMovimiento'] ?? ''}',
      cantidad: _toInt(json['cantidad']),
      fecha: '${json['fecha'] ?? ''}',
      productoId: _toInt(json['productoId'] ?? json['idProducto']),
      usuarioId: _toInt(json['usuarioId'] ?? json['idUsuario']),
      producto: rawProducto is Map
          ? Producto.fromJson(rawProducto.cast<String, dynamic>())
          : null,
      usuario: rawUsuario is Map
          ? Usuario.fromJson(rawUsuario.cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoMovimiento': tipoMovimiento,
      'cantidad': cantidad,
      'productoId': productoId,
    };
  }

  int get idMovimiento => id;
  int get idProducto => productoId;
  int get idUsuario => usuarioId;
}

int _toInt(dynamic value) {
  return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}
