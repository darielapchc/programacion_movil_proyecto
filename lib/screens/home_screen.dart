import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'inventario_screen.dart';
import 'categoria_screen.dart';
import 'agregar_producto_screen.dart';
import 'perfil_screen.dart';
import 'estadisticas_screen.dart';
import 'bienvenida_screen.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int paginaActual = 0;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();

  void cambiarPagina(int index) {
    setState(() {
      paginaActual = index;
    });
  }

  void mostrarFormularioNuevoProducto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                // Encabezado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nuevo producto',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Ingresa los datos del nuevo producto',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                // Campo 1
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del producto',
                    prefixIcon: const Icon(Icons.inventory_2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Campo 2
                TextField(
                  controller: codigoController,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    prefixIcon: const Icon(Icons.qr_code),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Campo 3
                TextField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botones
                Row(
                  children: [
                    // Cancelar
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Guardar
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (nombreController.text.isEmpty ||
                              codigoController.text.isEmpty ||
                              cantidadController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Completa todos los campos',
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${nombreController.text} preparado para agregar',
                              ),
                            ),
                          );
                          nombreController.clear();
                          codigoController.clear();
                          cantidadController.clear();
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    codigoController.dispose();
    cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> pantallas = [
      DashboardScreen(
        cambiarPagina: cambiarPagina,
      ),
      const InventarioScreen(),
      const CategoriasScreen(),
      const AgregarProductoScreen(),
    ];
    return Scaffold(
      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        title: const Text('LNE Stock'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      // ==========================================================
      // DRAWER
      // ==========================================================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
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
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.inventory_2,
                          size: 30,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'LNE Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sistema de inventario',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ==================================================
            // 1. INICIO
            // ==================================================
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                cambiarPagina(0);
                Navigator.pop(context);
              },
            ),
            // ==================================================
            // 2. INVENTARIO
            // ==================================================
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Inventario'),
              onTap: () {
                cambiarPagina(1);
                Navigator.pop(context);
              },
            ),
            // ==================================================
            // 3. CATEGORÍAS + EXPANSIONTILE
            // ==================================================
            ExpansionTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorías'),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 70,
                  ),
                  leading: const Icon(Icons.school),
                  title: const Text('Útiles escolares'),
                  onTap: () {
                    cambiarPagina(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 70,
                  ),
                  leading: const Icon(Icons.edit),
                  title: const Text('Papelería'),
                  onTap: () {
                    cambiarPagina(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 70,
                  ),
                  leading: const Icon(Icons.card_giftcard),
                  title: const Text('Novedades'),
                  onTap: () {
                    cambiarPagina(2);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            // ==================================================
            // 4. AGREGAR PRODUCTO
            // ==================================================
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Agregar producto'),
              onTap: () {
                cambiarPagina(3);
                Navigator.pop(context);
              },
            ),
            // ==================================================
            // 5. ESTADÍSTICAS
            // ==================================================
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Estadísticas'),
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
            const Divider(),
            // ==================================================
            // CERRAR SESIÓN - ÚLTIMA OPCIÓN
            // ==================================================
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BienvenidaScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      // ==========================================================
      // INDEXED STACK
      // ==========================================================
      body: IndexedStack(
        index: paginaActual,
        children: pantallas,
      ),
      // ==========================================================
      // BOTTOM NAVIGATION BAR
      // ==========================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaActual,
        onTap: cambiarPagina,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Agregar',
          ),
        ],
      ),
      // ==========================================================
      // FAB + BOTTOM SHEET
      // ==========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: mostrarFormularioNuevoProducto,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}