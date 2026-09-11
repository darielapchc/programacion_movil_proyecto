import '../core/api_client.dart';
import '../models/categorias.dart';

class CategoriaService {
  final ApiClient api;

  CategoriaService({ApiClient? api}) : api = api ?? ApiClient.instance;

  Future<List<Categorias>> listarCategorias() async {
    final response = await api.get('/categorias');
    final payload = responsePayload(response.data);
    final list = payload is List
        ? payload
        : payload is Map && payload['rows'] is List
            ? payload['rows'] as List
            : const [];

    return list
        .whereType<Map>()
        .map((item) => Categorias.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
}
