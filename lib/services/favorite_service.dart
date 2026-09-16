import '../core/api_client.dart';

class FavoriteService {
  final ApiClient api;

  FavoriteService({ApiClient? api}) : api = api ?? ApiClient.instance;

  Future<Set<int>> listarIds() async {
    final response = await api.get('/favoritos');
    final payload = responsePayload(response.data);
    final items = payload is List
        ? payload
        : payload is Map && payload['rows'] is List
            ? payload['rows'] as List
            : const [];

    return items.map(_productoId).whereType<int>().toSet();
  }

  Future<void> agregar(int productoId) async {
    await api.post('/favoritos/$productoId');
  }

  Future<void> eliminar(int productoId) async {
    await api.delete('/favoritos/$productoId');
  }

  int? _productoId(dynamic item) {
    if (item is num) return item.toInt();
    if (item is String) return int.tryParse(item);
    if (item is! Map) return null;

    final explicitId = item['productoId'] ?? item['idProducto'];
    if (explicitId is num) return explicitId.toInt();
    if (explicitId != null) return int.tryParse('$explicitId');

    final producto = item['producto'];
    if (producto is Map) {
      final nestedId = producto['id'] ?? producto['productoId'];
      if (nestedId is num) return nestedId.toInt();
      if (nestedId != null) return int.tryParse('$nestedId');
    }

    final id = item['id'];
    if (id is num) return id.toInt();
    return id == null ? null : int.tryParse('$id');
  }
}
