// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:inventario_application_1/models/producto.dart';

void main() {
  test('Producto.fromJson convierte los datos del inventario', () {
    final producto = Producto.fromJson({
      'id': 7,
      'nombre': 'Cuaderno',
      'codigo': 'CUA-001',
      'precio': 42.5,
      'stock': 12,
      'imagen': 'menu_book',
      'categoriaId': 3,
    });

    expect(producto.id, 7);
    expect(producto.nombre, 'Cuaderno');
    expect(producto.codigo, 'CUA-001');
    expect(producto.precio, 42.5);
    expect(producto.stock, 12);
    expect(producto.imagen, 'menu_book');
    expect(producto.categoriaId, 3);
  });
}
