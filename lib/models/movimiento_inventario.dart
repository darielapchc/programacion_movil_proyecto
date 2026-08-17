class MovimientoInventario {
  final int idMovimiento;
  final String tipoMovimiento; // "Entrada" o "Salida"
  final int cantidad;
  final String fecha;
  final int idUsuario;
  final int idProducto;

  MovimientoInventario({
    required this.idMovimiento,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fecha,
    required this.idUsuario,
    required this.idProducto,
  });
}