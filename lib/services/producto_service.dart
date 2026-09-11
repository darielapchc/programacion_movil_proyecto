import '../core/api_client.dart';
import '../models/producto.dart';

class ProductoService {
  final ApiClient api;

  ProductoService({ApiClient? api}) : api = api ?? ApiClient.instance;

  Future<List<Producto>> listarProductos() async {
    final response = await api.get('/productos');
    return _list(responsePayload(response.data));
  }

  Future<Producto> obtenerProducto(int id) async {
    final response = await api.get('/productos/$id');
    return Producto.fromJson(responsePayload(response.data));
  }

  Future<Producto> crearProducto(Producto producto) async {
    final response = await api.post('/productos', data: producto.toJson());
    return Producto.fromJson(responsePayload(response.data));
  }

  Future<Producto> actualizarProducto(int id, Producto producto) async {
    final response = await api.put('/productos/$id', data: producto.toJson());
    return Producto.fromJson(responsePayload(response.data));
  }

  Future<void> eliminarProducto(int id) async {
    await api.delete('/productos/$id');
  }

  List<Producto> _list(dynamic payload) {
    final list = payload is List
        ? payload
        : payload is Map && payload['rows'] is List
            ? payload['rows'] as List
            : const [];

    return list
        .whereType<Map>()
        .map((item) => Producto.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
}
