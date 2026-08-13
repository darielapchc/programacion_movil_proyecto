// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {

  final TextEditingController buscadorController =
      TextEditingController();

  final List<Map<String, dynamic>> productos = [
    {
      'nombre': 'Cuaderno Norma',
      'categoria': 'Cuadernos',
      'codigo': 'CU001',
      'precio': 95.00,
      'cantidad': 20,
    },
    {
      'nombre': 'Lápiz BIC',
      'categoria': 'Lápices',
      'codigo': 'LA001',
      'precio': 12.00,
      'cantidad': 4,
    },
    {
      'nombre': 'Marcadores Pelikan',
      'categoria': 'Arte',
      'codigo': 'MA001',
      'precio': 85.00,
      'cantidad': 12,
    },
    {
      'nombre': 'Resma de papel',
      'categoria': 'Papelería',
      'codigo': 'PA001',
      'precio': 120.00,
      'cantidad': 2,
    },
    {
      'nombre': 'Tijeras escolares',
      'categoria': 'Escolar',
      'codigo': 'TI001',
      'precio': 45.00,
      'cantidad': 0,
    },
  ];

  List<Map<String, dynamic>> productosFiltrados = [];

  @override
  void initState() {
    super.initState();

    productosFiltrados = List.from(productos);

    buscadorController.addListener(_buscarProducto);
  }

  void _buscarProducto() {

    final texto = buscadorController.text.toLowerCase();

    setState(() {

      productosFiltrados = productos.where((producto) {

        final nombre =
            producto['nombre'].toString().toLowerCase();

        final codigo =
            producto['codigo'].toString().toLowerCase();

        final categoria =
            producto['categoria'].toString().toLowerCase();

        return nombre.contains(texto) ||
            codigo.contains(texto) ||
            categoria.contains(texto);

      }).toList();

    });
  }

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Inventario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Productos disponibles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Consulta y busca los productos registrados.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),

            const SizedBox(height: 18),

            // BUSCADOR
            TextField(
              controller: buscadorController,

              decoration: InputDecoration(
                hintText: 'Buscar producto...',

                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                ),

                suffixIcon: buscadorController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          buscadorController.clear();
                        },
                      )
                    : null,

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CANTIDAD DE RESULTADOS
            Text(
              '${productosFiltrados.length} productos encontrados',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F5F5F),
              ),
            ),

            const SizedBox(height: 10),

            // LISTA
            Expanded(
              child: productosFiltrados.isEmpty
                  ? _sinResultados()
                  : ListView.builder(
                      itemCount: productosFiltrados.length,

                      itemBuilder: (context, index) {

                        final producto =
                            productosFiltrados[index];

                        return _productoInventarioCard(
                          producto,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productoInventarioCard(
      Map<String, dynamic> producto) {

    final int cantidad = producto['cantidad'];

    Color colorEstado;
    String textoEstado;
    IconData iconoEstado;

    if (cantidad == 0) {
      colorEstado = Colors.red;
      textoEstado = 'Agotado';
      iconoEstado = Icons.cancel;
    } else if (cantidad <= 5) {
      colorEstado = Colors.orange;
      textoEstado = 'Stock bajo';
      iconoEstado = Icons.warning_amber_rounded;
    } else {
      colorEstado = Colors.green;
      textoEstado = 'Disponible';
      iconoEstado = Icons.check_circle;
    }

    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      AppColors.primary.withOpacity(0.12),

                  child: const Icon(
                    Icons.inventory_2,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        producto['nombre'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        producto['categoria'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Código: ${producto['codigo']}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  'L. ${producto['precio'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Row(
                  children: [

                    Icon(
                      iconoEstado,
                      size: 19,
                      color: colorEstado,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      textoEstado,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorEstado,
                      ),
                    ),
                  ],
                ),

                Text(
                  '$cantidad unidades',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sinResultados() {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          const Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Intenta buscar por nombre, código o categoría.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5F5F5F),
            ),
          ),
        ],
      ),
    );
  }
}