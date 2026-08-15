import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import '../widgets/stock_status.dart';

class DetalleProductoScreen extends StatelessWidget {

  final Producto producto;

  const DetalleProductoScreen({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text("Detalle del Producto"),
        backgroundColor: const Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            //Icono o imagen del producto
            const CircleAvatar(
              radius: 70,
              backgroundColor: Color(0xFFEADBC8),
              child: Icon(
                Icons.inventory_2,
                size: 70,
                color: Color(0xFF8B5E3C),
              ),
            ),
            const SizedBox(height: 30),

            ProductoCard(
              nombre: producto.nombre,
              codigo: producto.codigo,
              categoria: producto.categoria,
              precio: producto.precio,
              cantidad: producto.cantidad,
              esFavorito: false,
              onFavorite: () {},
              // Al tocar la tarjeta regresamo a la pantalla anterior.
              onTap: () {
                Navigator.pop(context);
              },
              mostrarEstado: true,
              mostrarFavorito: false,
              colorAccento: Colors.brown,
            ),

            const SizedBox(height: 30),
              StockStatusWidget(
                cantidad: producto.cantidad,
                stockMinimo: 10,
                titulo: 'Estado del inventario',
              ),
            const SizedBox(height: 30),
            //Boton de editar producto
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  //¿Podria ir aqui una funcion de editar producto?
                  //Piensa Lia, piensaaa que son lqs 8 de la mañanaaa yaaaa!!

                },
                icon: const Icon(Icons.edit),
                label: const Text("Editar Producto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

// -- GUARDAR -- //

/* Lo dejo aqui porque va me equivoco y no sirve lo de rriba, aunque para eso esta el control de versiones va, pero X.

Widget datoProducto(String titulo, String valor){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );

  }

*/