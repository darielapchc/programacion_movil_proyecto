import 'categorias.dart';

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final String codigo;
  final double precio;
  final int stock;
  final String? imagen;
  final int? categoriaId;
  final Categorias? categoria;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion = '',
    required this.codigo,
    required this.precio,
    required this.stock,
    this.imagen,
    this.categoriaId,
    this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    final value = json['stock'] ?? json['cantidad'] ?? 0;
    return Producto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      codigo: (json['codigo'] ?? '').toString(),
      precio: double.tryParse('${json['precio'] ?? 0}') ?? 0,
      stock: value is num ? value.toInt() : int.tryParse('$value') ?? 0,
      imagen: json['imagen']?.toString(),
      categoriaId: (json['categoriaId'] as num?)?.toInt(),
      categoria: json['categoria'] is Map
          ? Categorias.fromJson(
              Map<String, dynamic>.from(json['categoria'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'codigo': codigo,
    'precio': precio,
    'stock': stock,
    'imagen': imagen,
    'categoriaId': categoriaId,
  };

  String get categoriaNombre => categoria?.nombre ?? '';
}
