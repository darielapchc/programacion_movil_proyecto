import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'inventario_screen.dart';
import 'categoria_screen.dart';
import 'agregar_producto_screen.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_principal.dart';

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
  final formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final codigoController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  String? categoriaSeleccionada;

  final List<String> categorias = [
    "Cuadernos",
    "Papelería",
    "Lápices",
    "Arte",
    "Oficina",
    "Tecnología",
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F5F0),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Indicador superior
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Nuevo producto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5E3C),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // NOMBRE
                    CampoTexto(
                      label: "Nombre",
                      icono: Icons.inventory,
                      controlador: nombreController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese el nombre";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // CÓDIGO
                    CampoTexto(
                      label: "Código",
                      icono: Icons.qr_code,
                      controlador: codigoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese el código";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // CATEGORÍA
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: categoriaSeleccionada,
                      decoration: InputDecoration(
                        labelText: "Categoría",
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: categorias.map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        setModalState(() {
                          categoriaSeleccionada = valor;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Seleccione una categoría";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // PRECIO
                    CampoTexto(
                      label: "Precio",
                      icono: Icons.attach_money,
                      controlador: precioController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese el precio";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // CANTIDAD
                    CampoTexto(
                      label: "Cantidad",
                      icono: Icons.numbers,
                      controlador: cantidadController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese la cantidad";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // BOTÓN GUARDAR
                    BotonPrincipal(
                      texto: "Guardar Producto",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(bottomSheetContext);

                          SnackBarHelper.mostrarConAccion(
                            this.context,
                            mensaje:
                                '${nombreController.text} preparado para agregar',
                            onVer: () {
                              cambiarPagina(1);
                            },
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // BOTÓN CANCELAR
                    TextButton(
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFF8B5E3C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
      const DashboardScreen(),
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
              height: 210,
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
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
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
               Navigator.pushNamed(context, '/estadisticas');
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/bienvenida',
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