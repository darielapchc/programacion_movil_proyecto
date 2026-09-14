import '../core/api_client.dart';
import '../models/movimiento_inventario.dart';

class MovimientoService {
  final ApiClient api;

  MovimientoService({ApiClient? api}) : api = api ?? ApiClient.instance;

  Future<List<MovimientoInventario>> listarMovimientos() async {
    final response = await api.get('/movimientos');
    final payload = responsePayload(response.data);
    final list = payload is List
        ? payload
        : payload is Map && payload['rows'] is List
            ? payload['rows'] as List
            : payload is Map && payload['items'] is List
                ? payload['items'] as List
                : const [];

    final movimientos = list
        .whereType<Map>()
        .map((item) => MovimientoInventario.fromJson(item.cast<String, dynamic>()))
        .toList();
    movimientos.sort((a, b) => _fecha(b).compareTo(_fecha(a)));
    return movimientos;
  }

  Future<MovimientoInventario> registrarMovimiento({
    required String tipoMovimiento,
    required int cantidad,
    required int productoId,
  }) async {
    final response = await api.post(
      '/movimientos',
      data: {
        'tipoMovimiento': tipoMovimiento,
        'cantidad': cantidad,
        'productoId': productoId,
      },
    );
    return MovimientoInventario.fromJson(responsePayload(response.data));
  }

  Future<MovimientoInventario> crearMovimiento(
    MovimientoInventario movimiento,
  ) async {
    return registrarMovimiento(
      tipoMovimiento: movimiento.tipoMovimiento,
      cantidad: movimiento.cantidad,
      productoId: movimiento.productoId,
    );
  }

  DateTime _fecha(MovimientoInventario movimiento) =>
      DateTime.tryParse(movimiento.fecha) ?? DateTime.fromMillisecondsSinceEpoch(0);
}
