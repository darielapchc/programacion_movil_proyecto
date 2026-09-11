import '../core/api_client.dart';
import '../models/movimiento_inventario.dart';

class MovimientoService {
  final ApiClient client;
  MovimientoService({ApiClient? client}) : client = client ?? ApiClient();
  Future<List<MovimientoInventario>> listar() async =>
      ApiClient.asList(await client.get('/movimientos'))
          .map(
            (e) => MovimientoInventario.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
}
