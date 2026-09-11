class MovimientoInventario {
  final int id;
  final String tipoMovimiento;
  final int cantidad;
  final String fecha;
  final int productoId;
  final int usuarioId;

  const MovimientoInventario({
    required this.id,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fecha,
    required this.productoId,
    required this.usuarioId,
  });

  factory MovimientoInventario.fromJson(Map<String, dynamic> json) {
    return MovimientoInventario(
      id: _toInt(json['id'] ?? json['idMovimiento']),
      tipoMovimiento: '${json['tipoMovimiento'] ?? ''}',
      cantidad: _toInt(json['cantidad']),
      fecha: '${json['fecha'] ?? ''}',
      productoId: _toInt(json['productoId'] ?? json['idProducto']),
      usuarioId: _toInt(json['usuarioId'] ?? json['idUsuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoMovimiento': tipoMovimiento,
      'cantidad': cantidad,
      'productoId': productoId,
      'usuarioId': usuarioId,
    };
  }

  int get idMovimiento => id;
  int get idProducto => productoId;
  int get idUsuario => usuarioId;
}

int _toInt(dynamic value) {
  return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}
