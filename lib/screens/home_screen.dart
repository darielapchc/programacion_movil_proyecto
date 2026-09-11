import 'package:flutter/material.dart';
import '../core/storage_service.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import 'dashboard_screen.dart';
import 'inventario_screen.dart';
import 'categoria_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  Usuario? user;
  @override
  void initState() {
    super.initState();
    StorageService().getUser().then((u) {
      if (mounted) setState(() => user = u);
    });
  }

  Future<void> logout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/bienvenida', (_) => false);
    }
  }

  @override
  Widget build(BuildContext c) {
    final screens = [
      DashboardScreen(onNavigate: (i) => setState(() => index = i)),
      const InventarioScreen(),
      const CategoriasScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('LNE Stock'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.fullName ?? 'LNE Stock'),
              accountEmail: Text(user?.email ?? ''),
              decoration: const BoxDecoration(color: AppColors.primary),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => setState(() => index = 0),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventario'),
              onTap: () => setState(() => index = 1),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorías'),
              onTap: () => setState(() => index = 2),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Estadísticas'),
              onTap: () => Navigator.pushNamed(context, '/estadisticas'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () => Navigator.pushNamed(context, '/perfil'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
        ],
      ),
      floatingActionButton: user?.role == 'admin'
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed(context, '/agregar-producto'),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo'),
            )
          : null,
    );
  }
}
