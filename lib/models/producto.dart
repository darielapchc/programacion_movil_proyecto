import 'categorias.dart';

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final String codigo;
  final double precio;
  final int stock;
  final String imagen;
  final int? categoriaId;
  final Categorias? categoria;

  const Producto({
    required this.id,
    required this.nombre,
    this.descripcion = '',
    required this.codigo,
    required this.precio,
    required this.stock,
    this.imagen = '',
    this.categoriaId,
    this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['categoria'];

    return Producto(
      id: _toInt(json['id']),
      nombre: '${json['nombre'] ?? ''}',
      descripcion: '${json['descripcion'] ?? ''}',
      codigo: '${json['codigo'] ?? ''}',
      precio: _toDouble(json['precio']),
      stock: _toInt(json['stock'] ?? json['cantidad']),
      imagen: '${json['imagen'] ?? ''}',
      categoriaId: json['categoriaId'] == null && json['idCategoria'] == null
          ? null
          : _toInt(json['categoriaId'] ?? json['idCategoria']),
      categoria: rawCategory is Map
          ? Categorias.fromJson(rawCategory.cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'codigo': codigo,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
      'categoriaId': categoriaId,
    };
  }

  int get cantidad => stock;
  String get categoriaNombre => categoria?.nombre ?? '';
}

int _toInt(dynamic value) {
  return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}

double _toDouble(dynamic value) {
  return value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
