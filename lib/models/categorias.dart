//import 'dart:js_interop';
//import 'package:flutter/material.dart';

class Categorias {
  final int idCategoria;
  final String nombre;
  final String descripcion;
  final String icono;
  final bool activo;

  Categorias({
    required this.idCategoria,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.activo,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(
      idCategoria: json['idCategoria'], 
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? "",
      icono: json['icono'] ?? "",
      activo: json['activo'] ?? true,
    );
  }
}