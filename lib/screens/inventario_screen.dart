import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../utils/app_colors.dart';
import '../widgets/producto_card.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final TextEditingController buscadorController =
      TextEditingController();

  // Controla si se muestra la lista o la cuadrícula.
  bool mostrarGrid = false;

  // Productos ficticios del inventario.
  final List<Map<String, dynamic>> productos = [
    {
      'id': 1,
      'nombre': 'Cuaderno Amigo',
      'categoria': 'Cuadernos',
      'codigo': 'CU001',
      'precio': 35.00,
      'cantidad': 30,
      'imagen': '',
    },
    {
      'id': 2,
      'nombre': 'Lápiz BIC',
      'categoria': 'Lápices',
      'codigo': 'LA001',
      'precio': 6.00,
      'cantidad': 20,
      'imagen': '',
    },
    {
      'id': 3,
      'nombre': 'Marcadores Sharpie',
      'categoria': 'Arte',
      'codigo': 'MA001',
      'precio': 22.00,
      'cantidad': 35,
      'imagen': '',
    },
    {
      'id': 4,
      'nombre': 'Resma de papel',
      'categoria': 'Papelería',
      'codigo': 'PA001',
      'precio': 135.00,
      'cantidad': 40,
      'imagen': '',
    },
    {
      'id': 5,
      'nombre': 'Colores Maped',
      'categoria': 'Escolar',
      'codigo': 'CO001',
      'precio': 65.00,
      'cantidad': 120,
      'imagen': '',
    },
    {
      'id': 6,
      'nombre': 'Block Liso',
      'categoria': 'Cuadernos',
      'codigo': 'BL001',
      'precio': 22.00,
      'cantidad': 24,
      'imagen': '',
    },
    {
      'id': 7,
      'nombre': 'Block Rayado',
      'categoria': 'Escolar',
      'codigo': 'BR001',
      'precio': 25.00,
      'cantidad': 24,
      'imagen': '',
    },
    {
      'id': 8,
      'nombre': 'Marcadores BIC',
      'categoria': 'Arte',
      'codigo': 'MB001',
      'precio': 30.00,
      'cantidad': 24,
      'imagen': '',
    },
    {
      'id': 9,
      'nombre': 'Cuaderno de Dibujo',
      'categoria': 'Escolar',
      'codigo': 'CD001',
      'precio': 10.00,
      'cantidad': 100,
      'imagen': '',
    },
    {
      'id': 10,
      'nombre': 'Cuaderno de Caligrafía',
      'categoria': 'Escolar',
      'codigo': 'CC001',
      'precio': 10.00,
      'cantidad': 80,
      'imagen': '',
    },
  ];

  List<Map<String, dynamic>> productosFiltrados = [];

  // Guarda los códigos de los productos favoritos.
  final Set<String> productosFavoritos = {};

  @override
  void initState() {
    super.initState();

    productosFiltrados = List.from(productos);

    buscadorController.addListener(_buscarProducto);
  }

  // Convierte el mapa a un objeto Producto.
  Producto _convertirAProducto(Map<String, dynamic> producto) {
    return Producto(
      id: producto['id'] ?? 0,
      nombre: producto['nombre'],
      categoria: producto['categoria'],
      codigo: producto['codigo'],
      precio: producto['precio'],
      cantidad: producto['cantidad'],
      imagen: producto['imagen'] ?? '',
    );
  }

  // Navega al detalle mediante una ruta con nombre.
  void _verDetalleProducto(Map<String, dynamic> producto) {
    final Producto productoModelo = _convertirAProducto(producto);

    Navigator.pushNamed(
      context,
      '/detalle',
      arguments: productoModelo,
    );
  }

  // Busca por nombre, código o categoría.
  void _buscarProducto() {
    final texto = buscadorController.text.toLowerCase();

    setState(() {
      productosFiltrados = productos.where((producto) {
        final nombre =
            producto['nombre'].toString().toLowerCase();

        final codigo =
            producto['codigo'].toString().toLowerCase();

        final categoria =
            producto['categoria'].toString().toLowerCase();

        return nombre.contains(texto) ||
            codigo.contains(texto) ||
            categoria.contains(texto);
      }).toList();
    });
  }

  // Alterna el estado de favorito.
  void _alternarFavorito(String codigo) {
    setState(() {
      if (productosFavoritos.contains(codigo)) {
        productosFavoritos.remove(codigo);
      } else {
        productosFavoritos.add(codigo);
      }
    });
  }

  // Muestra el diálogo para eliminar un producto.
  Future<void> _mostrarDialogoEliminar(
    BuildContext context,
    Map<String, dynamic> producto,
  ) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: Text(
            '¿Desea eliminar este producto?\n\n'
            '${producto['nombre']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      _eliminarProducto(producto);
    }
  }

  // Elimina un producto.
  void _eliminarProducto(Map<String, dynamic> producto) {
    final String codigo = producto['codigo'];

    setState(() {
      productos.removeWhere(
        (item) => item['codigo'] == codigo,
      );

      productosFavoritos.remove(codigo);

      productosFiltrados = productos.where((item) {
        final texto =
            buscadorController.text.toLowerCase();

        final nombre =
            item['nombre'].toString().toLowerCase();

        final codigoProducto =
            item['codigo'].toString().toLowerCase();

        final categoria =
            item['categoria'].toString().toLowerCase();

        return nombre.contains(texto) ||
            codigoProducto.contains(texto) ||
            categoria.contains(texto);
      }).toList();
    });
  }

  // SnackBar para mostrar mensajes.
  void _mostrarSnackBar({
    required String mensaje,
    String? accionTexto,
    VoidCallback? onAccion,
    Duration duracion = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: duracion,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        action: accionTexto != null && onAccion != null
            ? SnackBarAction(
                label: accionTexto,
                textColor: Colors.white,
                onPressed: onAccion,
              )
            : null,
      ),
    );
  }

  // Construye la lista de productos.
  Widget _construirLista() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: productosFiltrados.length,
      itemBuilder: (context, index) {
        final producto = productosFiltrados[index];

        final String codigo = producto['codigo'];
        final bool esFavorito =
            productosFavoritos.contains(codigo);

        return Dismissible(
          key: ValueKey(codigo),

          // Deslizar hacia la derecha.
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.centerLeft,
            child: const Row(
              children: [
                Icon(
                  Icons.visibility,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Ver detalle',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Deslizar hacia la izquierda.
          secondaryBackground: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.centerRight,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              _mostrarSnackBar(
                mensaje: 'Producto seleccionado.',
                accionTexto: 'VER',
                onAccion: () {
                  _verDetalleProducto(producto);
                },
              );

              return false;
            }

            _eliminarProducto(producto);

            _mostrarSnackBar(
              mensaje:
                  '${producto['nombre']} eliminado correctamente.',
            );

            return false;
          },

          child: GestureDetector(
            onLongPress: () {
              _mostrarDialogoEliminar(
                context,
                producto,
              );
            },
            child: ProductoCard(
              nombre: producto['nombre'],
              codigo: producto['codigo'],
              categoria: producto['categoria'],
              precio: producto['precio'],
              cantidad: producto['cantidad'],
              esFavorito: esFavorito,
              onTap: () {
                _verDetalleProducto(producto);
              },
              onFavorite: () {
                _alternarFavorito(codigo);
              },
              mostrarEstado: true,
              colorAccento: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  // Construye la cuadrícula de productos.
  Widget _construirGrid() {
    final double ancho = MediaQuery.of(context).size.width;

    // Responsive:
    // teléfono = 2 columnas
    // pantalla grande = 3 columnas
    final int columnas = ancho > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: productosFiltrados.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnas,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final producto = productosFiltrados[index];

        final String codigo = producto['codigo'];
        final bool esFavorito =
            productosFavoritos.contains(codigo);

        return GestureDetector(
          onTap: () {
            _verDetalleProducto(producto);
          },
          onLongPress: () {
            _mostrarDialogoEliminar(
              context,
              producto,
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen/representación visual del producto.
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 55,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    producto['nombre'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    producto['categoria'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'L. ${producto['precio'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Stock: ${producto['cantidad']}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(
                        esFavorito
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: esFavorito
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sinResultados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          const Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Intenta buscar por nombre, código o categoría.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5F5F5F),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Inventario',
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
              'Productos disponibles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Consulta y busca los productos registrados.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5F5F),
              ),
            ),

            const SizedBox(height: 18),

            // BUSCADOR
            TextField(
              controller: buscadorController,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',

                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                ),

                suffixIcon:
                    buscadorController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              buscadorController.clear();
                            },
                          )
                        : null,

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${productosFiltrados.length} productos encontrados',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5F5F5F),
                  ),
                ),

                // Selector de vista.
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Vista de lista',
                      onPressed: () {
                        setState(() {
                          mostrarGrid = false;
                        });
                      },
                      icon: Icon(
                        Icons.view_list,
                        color: !mostrarGrid
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),

                    IconButton(
                      tooltip: 'Vista de cuadrícula',
                      onPressed: () {
                        setState(() {
                          mostrarGrid = true;
                        });
                      },
                      icon: Icon(
                        Icons.grid_view,
                        color: mostrarGrid
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Column + Expanded + contenido scrolleable.
            Expanded(
              child: productosFiltrados.isEmpty
                  ? _sinResultados()
                  : mostrarGrid
                      ? _construirGrid()
                      : _construirLista(),
            ),
          ],
        ),
      ),
    );
  }
}