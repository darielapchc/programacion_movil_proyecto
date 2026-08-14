// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'inventario_screen.dart';
import 'categoria_screen.dart';
import 'agregar_producto_screen.dart';
import '../utils/app_colors.dart';
import 'perfil_screen.dart';
import 'estadisticas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int paginaActual = 0;

  //Funcion para cambiar de paginas.
  void cambiarPagina(int index) {
    setState(() {
      paginaActual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      DashboardScreen(cambiarPagina: cambiarPagina),
      const InventarioScreen(), 
      const CategoriasScreen(), // Integrada correctamente
      const AgregarProductoScreen(),
    ];

    return Scaffold(
      //Barra superior de la aplicacion
      appBar: AppBar(
        title: const Text('LNE Stock'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      //Aqui ya pongo el drawer

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            //Encabezado con lo del usuario
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),

              accountName: const Text(
                'Lia Jael',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              accountEmail: const Text(
                'Administradora de inventario',
              ),

              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),

            //Inicio
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
              onTap: () {
                cambiarPagina(0);
                Navigator.pop(context);
              },
            ),

            // Inventario
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text("Inventario"),
              onTap: () {
                cambiarPagina(1);
                Navigator.pop(context);
              },
            ),

            // Categorías
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Categorías"),
              onTap: () {
                cambiarPagina(2);
                Navigator.pop(context);
              },
            ),

            // Agregar producto
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Agregar producto"),
              onTap: () {
                cambiarPagina(3);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            // Estadísticas
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Estadísticas"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EstadisticasScreen(),
                  ),
                );
              },
            ),

            // Perfil
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PerfilScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      //Pantalla seleccionada
      body: pantallas[paginaActual],

      //Menu de navegacion inferior
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