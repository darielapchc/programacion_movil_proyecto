import '../core/api_client.dart';
import '../models/movimiento_inventario.dart';

class MovimientoService {
  final ApiClient api;

  MovimientoService({ApiClient? api}) : api = api ?? ApiClient.instance;

  Future<List<MovimientoInventario>> listarMovimientos() async {
    final response = await api.get('/movimientos');
    final payload = responsePayload(response.data);
    final list = payload is List ? payload : const [];

    return list
        .whereType<Map>()
        .map((item) => MovimientoInventario.fromJson(item.cast<String, dynamic>()))
        .toList();
  }

  Future<MovimientoInventario> crearMovimiento(
    MovimientoInventario movimiento,
  ) async {
    final response = await api.post(
      '/movimientos',
      data: movimiento.toJson(),
    );
    return MovimientoInventario.fromJson(responsePayload(response.data));
  }
}
