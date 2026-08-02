import 'package:flutter/material.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() =>
      _AgregarProductoScreenState();
}

class _AgregarProductoScreenState
    extends State<AgregarProductoScreen> {

  int cantidad = 1;

  List<String> productos = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Agregar Producto"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const TextField(
              decoration: InputDecoration(
                labelText: "Nombre del producto",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Cantidad",
              style: TextStyle(fontSize: 18),
            ),

            Row(

              children: [

                IconButton(
                  icon: const Icon(Icons.remove),

                  onPressed: () {

                    setState(() {

                      if (cantidad > 1) {
                        cantidad--;
                      }

                    });

                  },
                ),

                Text(
                  "$cantidad",
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add),

                  onPressed: () {

                    setState(() {

                      cantidad++;

                    });

                  },
                ),

              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {

                setState(() {

                  productos.add(
                      "Producto ${productos.length + 1}");

                });

              },

              child: const Text("Guardar Producto"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Productos Agregados",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(

              child: ListView.builder(

                itemCount: productos.length,

                itemBuilder: (context, index) {

                  return ListTile(

                    leading: const Icon(Icons.inventory),

                    title: Text(productos[index]),

                  );

                },

              ),

            )

          ],
        ),
      ),
    );
  }
}

