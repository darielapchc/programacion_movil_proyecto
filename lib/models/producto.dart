// modelo_producto.dart
class Producto {
  final int id;
  final String nombre;
  final String categoria; // O idCategoria según backend
  final String codigo;
  final double precio;
  final int cantidad;
  final String imagen;

  Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.codigo,
    required this.precio,
    required this.cantidad,
    required this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      categoria: json['categoria'] ?? '',
      codigo: json['codigo'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      cantidad: json['cantidad'] ?? 0,
      imagen: json['imagen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'codigo': codigo,
      'precio': precio,
      'cantidad': cantidad,
      'imagen': imagen,
    };
  }
}