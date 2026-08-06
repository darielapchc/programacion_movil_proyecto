import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import 'detalle_producto_screen.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Producto> productos = [
      Producto(
        id: 1,
        nombre: "Cuaderno Norma",
        categoria: "Cuadernos",
        codigo: "PR001",
        precio: 95,
        cantidad: 20,
        imagen: "",
      ),
      Producto(
        id: 2,
        nombre: "Lápiz HB",
        categoria: "Lápices",
        codigo: "PR002",
        precio: 10,
        cantidad: 50,
        imagen: "",
      ),
      Producto(
        id: 3,
        nombre: "Resma Carta",
        categoria: "Papelería",
        codigo: "PR003",
        precio: 180,
        cantidad: 15,
        imagen: "",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),

      appBar: AppBar(
        title: const Text("Inventario"),
        backgroundColor: const Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: productos.length,

                itemBuilder: (context, index) {

                  return ProductoCard(
                    producto: productos[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleProductoScreen(
                            producto: productos[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}