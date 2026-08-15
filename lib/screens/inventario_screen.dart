// ignore_for_file: deprecated_member_use, unused_import
import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../utils/app_colors.dart';
import 'detalle_producto_screen.dart';
import '../widgets/producto_card.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {

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

  // Navega a la pantalla de detalle del producto.
  void _verDetalleProducto(Map<String, dynamic> producto) {
    final Producto productoModelo =
        _convertirAProducto(producto);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleProductoScreen(
          producto: productoModelo,
        ),
      ),
    );
  }

  final TextEditingController buscadorController =
      TextEditingController();

  final List<Map<String, dynamic>> productos = [
    {
      'nombre': 'Cuaderno Norma',
      'categoria': 'Cuadernos',
      'codigo': 'CU001',
      'precio': 95.00,
      'cantidad': 20,
    },
    {
      'nombre': 'Lápiz BIC',
      'categoria': 'Lápices',
      'codigo': 'LA001',
      'precio': 12.00,
      'cantidad': 4,
    },
    {
      'nombre': 'Marcadores Pelikan',
      'categoria': 'Arte',
      'codigo': 'MA001',
      'precio': 85.00,
      'cantidad': 12,
    },
    {
      'nombre': 'Resma de papel',
      'categoria': 'Papelería',
      'codigo': 'PA001',
      'precio': 120.00,
      'cantidad': 2,
    },
    {
      'nombre': 'Tijeras escolares',
      'categoria': 'Escolar',
      'codigo': 'TI001',
      'precio': 45.00,
      'cantidad': 0,
    },
  ];

  List<Map<String, dynamic>> productosFiltrados = [];

  // Guarda los códigos de los productos marcados como favoritos.
  final Set<String> productosFavoritos = {};

  @override
  void initState() {
    super.initState();

    productosFiltrados = List.from(productos);

    buscadorController.addListener(_buscarProducto);
  }

  //Este es el metodo encargado de buscar los productos.
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

  //Alternar el estado de favorito de un producto
  void _alternarFavorito(String codigo) {
    setState(() {
      if (productosFavoritos.contains(codigo)) {
        productosFavoritos.remove(codigo);
      } else {
        productosFavoritos.add(codigo);
      }
    });
  }

  // Muestra el AlertDialog al mantener presionado un producto.
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
            '¿Desea eliminar este item?\n\n'
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

  // Elimina un producto de la lista principal.
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

  // SnackBar para confirmar una acción.
  void _mostrarSnackBar({
    required String mensaje,
    String? accionTexto,
    VoidCallback? onAccion,
    Duration duracion = const Duration(seconds: 5),
  }) {
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();

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

                suffixIcon: buscadorController.text.isNotEmpty
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

            const SizedBox(height: 20),

            // CANTIDAD DE RESULTADOS
            Text(
              '${productosFiltrados.length} productos encontrados',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F5F5F),
              ),
            ),

            const SizedBox(height: 10),

            // LISTA
            Expanded(
              child: productosFiltrados.isEmpty ? _sinResultados() : ListView.builder(
                itemCount: productosFiltrados.length,
                itemBuilder: (context, index) {
                  final producto = productosFiltrados[index];
                  final String codigo = producto['codigo'];
                  final bool esFavorito = productosFavoritos.contains(codigo);

                  return Dismissible(
                    key: ValueKey(codigo),

                    // Deslizar hacia la derecha.
                    background: Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Editar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Deslizar hacia la izquierda para eliminar.
                    secondaryBackground: Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
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

                    // Determina qué ocurre con cada dirección.
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // EDITAR
                        _mostrarSnackBar(
                          mensaje: 'Producto seleccionado.',
                          accionTexto: 'VER', // La acción VER queda preparada
                          onAccion: () {
                            _verDetalleProducto(producto); // para navegar a otra pantalla.
                          },
                        );
                        return false;
                      }

                      // ELIMINAR
                      _eliminarProducto(producto);
                      _mostrarSnackBar(
                        mensaje: '${producto['nombre']} eliminado correctamente.',
                      );
                      return false;
                    },

                    child: GestureDetector(
                      //Mantener presionado
                      onLongPress: () {
                        _mostrarDialogoEliminar(
                          context,
                          producto,
                        );
                      },

                      //Aqui agrego el widget personalizado.

                      child: ProductoCard(
                        nombre: producto['nombre'],
                        codigo: producto['codigo'],
                        categoria: producto['categoria'],
                        precio: producto['precio'],
                        cantidad: producto['cantidad'],

                        //Estado del favorito
                        esFavorito: esFavorito,

                        //callback para abrir el detalles
                        onTap: () {
                          _verDetalleProducto(producto,);
                        },

                        //Callback para cambiar el favorito
                        onFavorite: () {
                          _alternarFavorito(codigo,);
                        },

                        mostrarEstado: true,
                        colorAccento: AppColors.primary,

                      ),
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
}