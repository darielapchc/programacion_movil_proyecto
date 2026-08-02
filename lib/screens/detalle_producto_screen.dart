import 'package:flutter/material.dart';

class DetalleProductoScreen extends StatefulWidget {
  const DetalleProductoScreen({super.key});

  @override
  State<DetalleProductoScreen> createState() =>
      _DetalleProductoScreenState();
}

class _DetalleProductoScreenState
    extends State<DetalleProductoScreen> {

  bool mostrarInfo = false;
  bool disponible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Producto"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Icon(
              Icons.inventory_2,
              size: 120,
              color: Colors.indigo,
            ),

            const SizedBox(height: 20),

            const Text(
              "Cuaderno Norma",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color:
                    disponible ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                disponible ? "Disponible" : "Agotado",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {
                setState(() {
                  mostrarInfo = !mostrarInfo;
                });
              },

              child: Text(
                mostrarInfo
                    ? "Ocultar Información"
                    : "Mostrar Información",
              ),
            ),

            const SizedBox(height: 15),

            if (mostrarInfo) ...[
              const Text("Código: P001"),
              const Text("Categoría: Cuadernos"),
              const Text("Precio: L.85.00"),
              const Text("Cantidad: 25"),
            ],

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {
                setState(() {
                  disponible = !disponible;
                });
              },

              child: const Text("Cambiar Estado"),
            ),

          ],
        ),
      ),
    );
  }
}