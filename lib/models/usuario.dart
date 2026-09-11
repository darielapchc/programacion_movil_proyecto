class Usuario {
  final int id;
  final String fullName;
  final String email;
  final String role;

  Usuario({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: (json['id'] as num?)?.toInt() ?? 0,
    fullName: (json['fullName'] ?? json['nombre'] ?? '').toString(),
    email: (json['email'] ?? json['correo'] ?? '').toString(),
    role: (json['role'] ?? json['rol'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'role': role,
  };
}
