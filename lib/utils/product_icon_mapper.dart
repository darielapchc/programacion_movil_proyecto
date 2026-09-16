import 'package:flutter/material.dart';

class ProductIconMapper {
  static const Map<String, IconData> icons = {
    // Categorías existentes
    'menu_book': Icons.menu_book,
    'edit': Icons.edit,
    'description': Icons.description,
    'palette': Icons.palette,
    'business_center': Icons.business_center,
    'school': Icons.school,

    // Papelería y productos adicionales
    'create': Icons.create,
    'brush': Icons.brush,
    'backspace': Icons.backspace,
    'straighten': Icons.straighten,
    'content_cut': Icons.content_cut,
    'inventory_2': Icons.inventory_2,
    'folder': Icons.folder,
    'print': Icons.print,
    'computer': Icons.computer,
    'calculate': Icons.calculate,
    'auto_stories': Icons.auto_stories,
    'sticky_note_2': Icons.sticky_note_2,
    'construction': Icons.construction,
  };

  static IconData getIcon(String? key) {
    if (key == null || key.isEmpty) {
      return Icons.inventory_2;
    }

    return icons[key] ?? Icons.inventory_2;
  }
}