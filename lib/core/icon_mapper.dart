import 'package:flutter/material.dart';

//Este tendra que modificarse con iconos de "Libreria"
const Map<String, IconData> _iconosPorNombre = {
  "plumbing": Icons.plumbing,
  "electrical_services": Icons.electrical_services,
  "carpenter": Icons.carpenter,
  "format_paint": Icons.format_paint,
  "cleaning_services": Icons.cleaning_services,
  "yard": Icons.yard,
  "ac_unit": Icons.ac_unit,
  "handyman": Icons.handyman,
  "pest_control": Icons.pest_control,
  "build": Icons.build,
  "roofing": Icons.roofing,
  "plumbing_outlined": Icons.plumbing_outlined,
};

IconData mapearIcono(String nombreIcono) {
  return _iconosPorNombre[nombreIcono] ?? Icons.miscellaneous_services;
}