import 'package:flutter/material.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  final List<Map<String, dynamic>> categorias = const [
    {"nombre": "Cuadernos", "icono": Icons.book, "cantidad": 12},
    {"nombre": "Papelería", "icono": Icons.description, "cantidad": 25},
    {"nombre": "Lápices", "icono": Icons.edit, "cantidad": 40},
    {"nombre": "Arte", "icono": Icons.palette, "cantidad": 8},
    {"nombre": "Oficina", "icono": Icons.work, "cantidad": 15},
    {"nombre": "Tecnología", "icono": Icons.devices, "cantidad": 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text("Categorías"),
        backgroundColor: const Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          itemCount: categorias.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final cat = categorias[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Categoría: ${cat['nombre']}")),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      // ignore: deprecated_member_use
                      backgroundColor: const Color(0xFF8B5E3C).withOpacity(0.15),
                      child: Icon(cat['icono'], color: const Color(0xFF8B5E3C), size: 28),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['nombre'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${cat['cantidad']} productos",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}