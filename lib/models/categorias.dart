class Categorias {
  final int id;
  final String nombre;
  final String descripcion;
  final String icono;
  final bool activo;

  Categorias({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.activo,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
    id: (json['id'] as num?)?.toInt() ?? 0,
    nombre: (json['nombre'] ?? '').toString(),
    descripcion: (json['descripcion'] ?? '').toString(),
    icono: (json['icono'] ?? '').toString(),
    activo: json['activo'] is bool ? json['activo'] as bool : true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'icono': icono,
    'activo': activo,
  };
}
