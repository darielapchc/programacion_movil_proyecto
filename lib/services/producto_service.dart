import '../core/api_client.dart';
import '../models/producto.dart';

class ProductoService {
  final ApiClient client;
  ProductoService({ApiClient? client}) : client = client ?? ApiClient();
  Future<List<Producto>> listar() async => ApiClient.asList(
    await client.get('/productos'),
  ).map((e) => Producto.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  Future<Producto> crear(Map<String, dynamic> data) async => Producto.fromJson(
    Map<String, dynamic>.from(
      await client.post('/productos', body: data) as Map,
    ),
  );
  Future<void> eliminar(int id) async {
    await client.delete('/productos/$id');
  }
}
