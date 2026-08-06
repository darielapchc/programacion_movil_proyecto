import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import 'detalle_producto_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Producto> _todosLosProductos = [
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

  List<Producto> _productosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _productosFiltrados = _todosLosProductos;
  }

  void _filtrarProductos(String query) {
    final queryLower = query.toLowerCase();
    setState(() {
      _productosFiltrados = _todosLosProductos.where((p) {
        return p.nombre.toLowerCase().contains(queryLower) ||
               p.codigo.toLowerCase().contains(queryLower) ||
               p.categoria.toLowerCase().contains(queryLower);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _searchController,
              onChanged: _filtrarProductos,
              decoration: InputDecoration(
                hintText: "Buscar por nombre, código o categoría...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filtrarProductos('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _productosFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        "No se encontraron productos",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _productosFiltrados.length,
                      itemBuilder: (context, index) {
                        final producto = _productosFiltrados[index];
                        return ProductoCard(
                          producto: producto,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalleProductoScreen(
                                  producto: producto,
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