import 'package:flutter/material.dart';
import '../core/storage_service.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Usuario? user;
  @override
  void initState() {
    super.initState();
    StorageService().getUser().then((u) {
      if (mounted) setState(() => user = u);
    });
  }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(
      title: const Text('Mi Perfil'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 55, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            user?.fullName ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(user?.role ?? '', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Nombre'),
                  subtitle: Text(user?.fullName ?? ''),
                ),
                ListTile(
                  title: const Text('Correo electrónico'),
                  subtitle: Text(user?.email ?? ''),
                ),
                ListTile(
                  title: const Text('Rol'),
                  subtitle: Text(user?.role ?? ''),
                ),
              ],
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () async {
              await AuthService().logout();
              if (c.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  c,
                  '/bienvenida',
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ),
  );
}
