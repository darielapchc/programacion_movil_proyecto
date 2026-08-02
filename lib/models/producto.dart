class Producto {
  String nombre;
  double precio;
  int cantidad;
  String categoria;

  Producto({
    required this.nombre,
    required this.precio, 
    required this.cantidad,
    required this.categoria,
  });

  bool disponible(){
    return cantidad > 0;
  }

  String obtenerInformacion(){
    return '$nombre - L. $precio';
  }
}