class Usuario {
  final int id;
  final String fullName;
  final String email;
  final String role;

  const Usuario({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: _toInt(json['id'] ?? json['idUsuario']),
      fullName: '${json['fullName'] ?? json['nombre'] ?? ''}',
      email: '${json['email'] ?? json['correo'] ?? ''}',
      role: '${json['role'] ?? json['rol'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
    };
  }

  int get idUsuario => id;
  String get nombre => fullName;
  String get correo => email;
  String get rol => role;
}

int _toInt(dynamic value) {
  return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}
