import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'inventario_screen.dart';
//import 'categorias_screen.dart';
import 'agregar_producto_screen.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int paginaActual = 0;
  void cambiarPagina(int index) {
    setState(() {
      paginaActual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      DashboardScreen(
        cambiarPagina: cambiarPagina,
      ),
      const InventarioScreen(),
      //const CategoriasScreen(),
      const AgregarProductoScreen(),
    ];
    return Scaffold(
      body: pantallas[paginaActual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaActual,
        onDestinationSelected: cambiarPagina,
        indicatorColor: AppColors.secondary,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2),
            label: "Inventario",
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: "Categorías",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box),
            label: "Agregar",
          ),
        ],
      ),
    );
  }
}