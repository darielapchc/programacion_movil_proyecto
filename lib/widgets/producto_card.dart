import 'package:flutter/material.dart';
//import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  //Datos obligatorio para los prodductos.
  final String nombre;
  final String codigo;
  final String categoria;
  final double precio;
  final int cantidad;

  //Los que estableci como parametros opcionales
  final bool mostrarEstado;
  final Color colorAccento;

  //Los famosos callbacks
  final VoidCallback onTap; // Abrir detalle del producto
  final VoidCallback onFavorite; //Ejecutar accion de poner el corazoncito como lo tenia anteriormente.
  final bool esFavorito;

  const ProductoCard({
    super.key,
    required this.nombre,
    required this.codigo,
    required this.cantidad,
    required this.categoria,
    required this.precio,
    required this.onTap,
    required this.onFavorite,
    required this.esFavorito,
    this.mostrarEstado = true,
    this.colorAccento = Colors.brown,
  });

  @override
  Widget build(BuildContext context) {

    //Determinar el estado del inventario
    String textoEstado = '';
    Color colorEstado;
    IconData iconoEstado;

    if (cantidad == 0) {
      textoEstado = 'Agotado';
      colorEstado = Colors.red;
      iconoEstado = Icons.error_outline;
    } else if (cantidad <= 5) {
      textoEstado = 'Stock bajo';
      colorEstado = Colors.yellow;
      iconoEstado = Icons.warning_amber_rounded;
    } else {
      textoEstado = 'Disponible';
      colorEstado = Colors.green;
      iconoEstado = Icons.check_circle_outline;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: colorAccento.withOpacity(0.15),
          child: Icon(
            Icons.inventory_2,
            color: colorAccento,
          ),
        ),

        title: Text(
          nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código: $codigo"),
            Text("Categoría: $categoria"),
            Text("Cantidad: $cantidad"),
            Text("Precio: L. ${precio.toStringAsFixed(2)}"),

            //Widget condicional
            mostrarEstado 
            ? Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: colorEstado.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconoEstado,
                    size: 16,
                    color: colorEstado,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    textoEstado,
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
            : const SizedBox.shrink(),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Favorito',
              icon: Icon( 
                esFavorito ? Icons.favorite : Icons.favorite_border,
                color: esFavorito ? Colors.red : Colors.grey,
              ),
              onPressed: onFavorite,
            ), 
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        )
      ),
    );
  }
}