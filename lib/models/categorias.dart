//import 'dart:js_interop';
//import 'package:flutter/material.dart';

class Categorias {
  final int id;
  final String nombre;
  final String descripcion;
  final String icono;
  final bool activo;

  const Categorias({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.activo,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(
      id: _toInt(json['id'] ?? json['idCategoria']),
      nombre: '${json['nombre'] ?? ''}',
      descripcion: '${json['descripcion'] ?? ''}',
      icono: '${json['icono'] ?? ''}',
      activo: json['activo'] is bool ? json['activo'] as bool : true,
    );
  }

  int get idCategoria => id;
}

int _toInt(dynamic value) {
  return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}
