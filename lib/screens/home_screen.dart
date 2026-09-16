// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'inventario_screen.dart';
import 'categoria_screen.dart';
import 'agregar_producto_screen.dart';

import '../services/auth_service.dart';
import '../core/api_client.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int paginaActual = 0;
  bool _esAdmin = false;
  final List<Widget?> _pantallas = [
    null,
    null,
    null,
    null,
  ];

  @override
  void initState() {
    super.initState();
    _cargarRol();
  }

  Future<void> _cargarRol() async {
    final role = await ApiClient.instance.storage.getRole();
    if (mounted) setState(() => _esAdmin = role?.toLowerCase() == 'admin');
  }
  void cambiarPagina(int index) {
    if (index < 0 || index > 3 || (index == 3 && !_esAdmin)) return;

    setState(() {
      _pantallas[index] ??= _crearPantalla(index);
      paginaActual = index;
    });
  }

  Widget _crearPantalla(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(onNavigate: cambiarPagina);
      case 1:
        return const InventarioScreen();
      case 2:
        return const CategoriasScreen();
      case 3:
        return const AgregarProductoScreen();
      default:
        return const SizedBox.shrink();
    }
  }
  Future<void> _cerrarSesion() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/bienvenida',
      (route) => false,
    );
  }

  Future<void> _abrirFormularioNuevoProducto() async {
    await Navigator.pushNamed(context, '/agregar-producto');
  }

  @override
  Widget build(BuildContext context) {
    _pantallas[0] ??= _crearPantalla(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LNE Stock'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Encabezado
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    15,
                    20,
                    15,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'LNE Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sistema de inventario',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: paginaActual == 0,
              selectedColor: AppColors.primary,
              onTap: () {
                cambiarPagina(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Inventario'),
              selected: paginaActual == 1,
              selectedColor: AppColors.primary,
              onTap: () {
                cambiarPagina(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorías'),
              selected: paginaActual == 2,
              selectedColor: AppColors.primary,
              onTap: () {
                cambiarPagina(2);
                Navigator.pop(context);
              },
            ),
            if (_esAdmin)
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('Agregar producto'),
                selected: paginaActual == 3,
                selectedColor: AppColors.primary,
                onTap: () {
                  cambiarPagina(3);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Estadísticas'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  '/estadisticas',
                );
              },
            ),
            if (_esAdmin)
              ListTile(
                leading: const Icon(Icons.swap_vert),
                title: const Text('Movimientos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/movimientos');
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: paginaActual,
        children: [
          for (final pantalla in _pantallas)
            pantalla ?? const SizedBox.shrink(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaActual,
        onTap: cambiarPagina,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Inventario',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categorías',
          ),

          if (_esAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: 'Agregar',
            ),
        ],
      ),
      floatingActionButton: _esAdmin
          ? FloatingActionButton.extended(
              onPressed: _abrirFormularioNuevoProducto,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}
