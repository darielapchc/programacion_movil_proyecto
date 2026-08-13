import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Avatar
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            // Nombre
            const Text(
              'Isis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 5),

            // Rol
            Text(
              'Administrador',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 30),

            // Información personal
            _seccionTitulo(
              'Información personal',
              Icons.person_outline,
            ),

            const SizedBox(height: 10),

            _informacionCard(
              icono: Icons.person,
              titulo: 'Nombre',
              valor: 'Isis',
            ),

            _informacionCard(
              icono: Icons.email_outlined,
              titulo: 'Correo electrónico',
              valor: 'usuario@lnestock.com',
            ),

            _informacionCard(
              icono: Icons.badge_outlined,
              titulo: 'Rol',
              valor: 'Administrador',
            ),

            const SizedBox(height: 25),

            // Opciones
            _seccionTitulo(
              'Opciones',
              Icons.settings_outlined,
            ),

            const SizedBox(height: 10),

            _opcionCard(
              icono: Icons.settings,
              titulo: 'Configuración',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Configuración próximamente',
                    ),
                  ),
                );
              },
            ),

            _opcionCard(
              icono: Icons.info_outline,
              titulo: 'Acerca de LNE Stock',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'LNE Stock',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Sistema de inventario de Librería y Novedades Emanuel',
                );
              },
            ),

            const SizedBox(height: 20),

            // Cerrar sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _mostrarCerrarSesion(context);
                },

                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),

                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Título de cada sección
  Widget _seccionTitulo(
    String titulo,
    IconData icono,
  ) {
    return Row(
      children: [
        Icon(
          icono,
          color: AppColors.primary,
        ),

        const SizedBox(width: 8),

        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  // Tarjeta de información
  Widget _informacionCard({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: Icon(
            icono,
            color: AppColors.primary,
          ),
        ),

        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),

        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }

  // Tarjeta de opciones
  Widget _opcionCard({
    required IconData icono,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(
          icono,
          color: AppColors.primary,
        ),

        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }

  // Diálogo para cerrar sesión
  void _mostrarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Cerrar sesión',
          ),

          content: const Text(
            '¿Estás segura de que deseas cerrar sesión?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // Más adelante conectaremos esto
                // con LoginScreen.
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),

              child: const Text(
                'Cerrar sesión',
              ),
            ),
          ],
        );
      },
    );
  }
}