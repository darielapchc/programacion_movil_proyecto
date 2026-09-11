class MovimientoInventario {
  final int id;
  final String tipoMovimiento;
  final int cantidad;
  final String fecha;
  final int productoId;
  final int usuarioId;

  MovimientoInventario({
    required this.id,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fecha,
    required this.productoId,
    required this.usuarioId,
  });

  factory MovimientoInventario.fromJson(Map<String, dynamic> json) =>
      MovimientoInventario(
        id: (json['id'] as num?)?.toInt() ?? 0,
        tipoMovimiento: (json['tipoMovimiento'] ?? '').toString().toUpperCase(),
        cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
        fecha: (json['fecha'] ?? '').toString(),
        productoId: (json['productoId'] as num?)?.toInt() ?? 0,
        usuarioId: (json['usuarioId'] as num?)?.toInt() ?? 0,
      );
}
