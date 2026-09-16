import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../models/producto.dart';
import '../utils/app_colors.dart';
import '../utils/product_icon_mapper.dart';

class DetalleProductoScreen extends StatefulWidget {
  const DetalleProductoScreen({
    super.key,
  });

  @override
  State<DetalleProductoScreen> createState() =>
      _DetalleProductoScreenState();
}

class _DetalleProductoScreenState
    extends State<DetalleProductoScreen> {
  late Producto producto;
  bool _esAdmin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    producto =
        ModalRoute.of(context)!
            .settings
            .arguments as Producto;
    ApiClient.instance.storage.getRole().then((role) {
      if (mounted) setState(() => _esAdmin = role?.toLowerCase() == 'admin');
    });
  }

  Future<void> _editarProducto() async {
    final productoActualizado =
        await Navigator.pushNamed(
      context,
      '/agregar-producto',
      arguments: producto,
    );

    if (!mounted ||
        productoActualizado is! Producto) {
      return;
    }

    final productoConStockActual = Producto(
      id: producto.id,
      nombre: productoActualizado.nombre,
      descripcion: productoActualizado.descripcion,
      codigo: productoActualizado.codigo,
      precio: productoActualizado.precio,
      stock: producto.stock,
      imagen: productoActualizado.imagen,
      categoriaId:
          productoActualizado.categoriaId ?? producto.categoriaId,
      categoria: productoActualizado.categoria ?? producto.categoria,
      categoriaNombreTexto: productoActualizado.categoriaNombreTexto.isEmpty
          ? producto.categoriaNombreTexto
          : productoActualizado.categoriaNombreTexto,
    );

    setState(() {
      producto = productoConStockActual;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Producto actualizado correctamente',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Detalle del producto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =========================
            // ICONO DEL PRODUCTO
            // =========================

            AspectRatio(
              aspectRatio: 1.65,

              child: Container(
                width: double.infinity,

                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 4),
                    ),
                  ],
                ),

                child: Icon(
                  ProductIconMapper.getIcon(
                    producto.imagen,
                  ),
                  size: 90,
                  color:
                      AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // NOMBRE
            // =========================

            Text(
              producto.nombre,

              style: const TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 8),

            // =========================
            // CATEGORÍA
            // =========================

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration:
                  BoxDecoration(
                color:
                    AppColors.primary
                        .withValues(
                  alpha: 0.12,
                ),

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Text(
                producto.categoriaNombre,

                style: const TextStyle(
                  color:
                      AppColors.primary,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // INFORMACIÓN
            // =========================

            Card(
              elevation: 2,
              color: Colors.white,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(
                  18,
                ),

                child: Column(
                  children: [
                    _datoProducto(
                      icono: Icons.qr_code,
                      titulo: 'Código',
                      valor:
                          producto.codigo,
                    ),

                    if (producto
                        .descripcion
                        .isNotEmpty) ...[
                      const Divider(),

                      _datoProducto(
                        icono: Icons
                            .description_outlined,
                        titulo:
                            'Descripción',
                        valor: producto
                            .descripcion,
                      ),
                    ],

                    const Divider(),

                    _datoProducto(
                      icono: Icons
                          .category_outlined,
                      titulo: 'Categoría',
                      valor: producto
                          .categoriaNombre,
                    ),

                    const Divider(),

                    _datoProducto(
                      icono:
                          Icons.attach_money,
                      titulo: 'Precio',
                      valor:
                          'L. ${producto.precio.toStringAsFixed(2)}',
                    ),

                    const Divider(),

                    _datoProducto(
                      icono: Icons
                          .inventory_2_outlined,
                      titulo:
                          'Cantidad disponible',
                      valor:
                          '${producto.cantidad} unidades',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // ESTADO
            // =========================

            const Text(
              'Estado del inventario',

              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 12),

            _estadoInventario(
              producto.cantidad,
            ),

            const SizedBox(height: 30),

            // =========================
            // EDITAR
            // =========================

            if (_esAdmin)
              SizedBox(
              width: double.infinity,
              height: 50,

              child:
                  OutlinedButton.icon(
                onPressed:
                    _editarProducto,

                icon: const Icon(
                  Icons.edit,
                ),

                label: const Text(
                  'Editar producto',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      AppColors.primary,

                  side:
                      const BorderSide(
                    color:
                        AppColors.primary,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // REGRESAR
            // =========================

            SizedBox(
              width: double.infinity,
              height: 50,

              child:
                  ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                    producto,
                  );
                },

                icon: const Icon(
                  Icons.arrow_back,
                ),

                label: const Text(
                  'Regresar al inventario',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datoProducto({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Row(
      children: [
        Container(
          padding:
              const EdgeInsets.all(10),

          decoration:
              BoxDecoration(
            color:
                AppColors.background,
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),

          child: Icon(
            icono,
            color:
                AppColors.primary,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                titulo,

                style:
                    const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                valor,

                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _estadoInventario(
    int cantidad,
  ) {
    String texto;
    IconData icono;

    if (cantidad == 0) {
      texto = 'Sin existencias';
      icono =
          Icons.error_outline;
    } else if (cantidad <= 10) {
      texto = 'Stock bajo';
      icono =
          Icons.warning_amber_rounded;
    } else {
      texto = 'Stock disponible';
      icono =
          Icons.check_circle_outline;
    }

    final Color color = cantidad == 0
        ? Colors.red
        : cantidad <= 10
            ? Colors.orange
            : Colors.green;

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),

        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),

      child: Row(
        children: [
          Icon(
            icono,
            color: color,
          ),

          const SizedBox(width: 12),

          Text(
            texto,

            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}