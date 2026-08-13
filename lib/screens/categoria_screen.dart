// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {
        'nombre': 'Cuadernos',
        'icono': Icons.menu_book,
        'cantidad': 25,
      },
      {
        'nombre': 'Lápices',
        'icono': Icons.edit,
        'cantidad': 18,
      },
      {
        'nombre': 'Papelería',
        'icono': Icons.description,
        'cantidad': 32,
      },
      {
        'nombre': 'Arte',
        'icono': Icons.palette,
        'cantidad': 15,
      },
      {
        'nombre': 'Oficina',
        'icono': Icons.business_center,
        'cantidad': 20,
      },
      {
        'nombre': 'Escolar',
        'icono': Icons.school,
        'cantidad': 15,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Categorías',
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
              'Categorías de productos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Organiza los productos de la librería.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: categorias.length,

                itemBuilder: (context, index) {
                  final categoria = categorias[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),

                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            AppColors.primary.withOpacity(0.12),

                        child: Icon(
                          categoria['icono'] as IconData,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),

                      title: Text(
                        categoria['nombre'] as String,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),

                      subtitle: Text(
                        '${categoria['cantidad']} productos',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 17,
                        color: AppColors.primary,
                      ),

                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Seleccionaste ${categoria['nombre']}',
                            ),
                          ),
                        );
                      },
                    ),
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