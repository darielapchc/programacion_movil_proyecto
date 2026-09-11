import '../core/api_client.dart';
import '../models/categorias.dart';

class CategoriaService {
  final ApiClient client;
  CategoriaService({ApiClient? client}) : client = client ?? ApiClient();
  Future<List<Categorias>> listarActivas() async =>
      ApiClient.asList(
            await client.get(
              '/categorias',
              queryParameters: {'activo': 'true'},
            ),
          )
          .map((e) => Categorias.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
}
