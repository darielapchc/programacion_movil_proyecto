import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../utils/app_colors.dart';

class DetalleProductoScreen extends StatefulWidget {
  const DetalleProductoScreen({super.key});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  late Producto producto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    producto = ModalRoute.of(context)!.settings.arguments as Producto;
  }

  Future<void> _editarProducto() async {
    final productoActualizado = await Navigator.pushNamed(
      context,
      '/agregar-producto',
      arguments: producto,
    );

    if (!mounted || productoActualizado is! Producto) return;

    setState(() => producto = productoActualizado);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto actualizado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Detalle del producto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            AspectRatio(
              aspectRatio: 1.65,
              child: Container(
                width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: producto.imagen.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        producto.imagen,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Icon(
                      Icons.inventory_2_outlined,
                      size: 90,
                      color: AppColors.primary,
                    ),
              ),
            ),

            const SizedBox(height: 25),

            // Nombre
            Text(
              producto.nombre,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 8),

            // Categoría
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                producto.categoriaNombre,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Información
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _datoProducto(
                      icono: Icons.qr_code,
                      titulo: 'Código',
                      valor: producto.codigo,
                    ),

                    if (producto.descripcion.isNotEmpty) ...[
                      const Divider(),
                      _datoProducto(
                        icono: Icons.description_outlined,
                        titulo: 'Descripcion',
                        valor: producto.descripcion,
                      ),
                    ],

                    const Divider(),

                    _datoProducto(
                      icono: Icons.category_outlined,
                      titulo: 'Categoría',
                      valor: producto.categoriaNombre,
                    ),

                    const Divider(),

                    _datoProducto(
                      icono: Icons.attach_money,
                      titulo: 'Precio',
                      valor:
                          'L. ${producto.precio.toStringAsFixed(2)}',
                    ),

                    const Divider(),

                    _datoProducto(
                      icono: Icons.inventory_2_outlined,
                      titulo: 'Cantidad disponible',
                      valor: '${producto.cantidad} unidades',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Estado del inventario
            const Text(
              'Estado del inventario',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 12),

            _estadoInventario(producto.cantidad),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _editarProducto,
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Editar producto',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botón regresar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, producto);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Regresar al inventario',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icono,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _estadoInventario(int cantidad) {
    String texto;
    IconData icono;

    if (cantidad == 0) {
      texto = 'Sin existencias';
      icono = Icons.error_outline;
    } else if (cantidad <= 10) {
      texto = 'Stock bajo';
      icono = Icons.warning_amber_rounded;
    } else {
      texto = 'Stock disponible';
      icono = Icons.check_circle_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cantidad == 0
            ? Colors.red.withValues(alpha: 0.10)
            : cantidad <= 10
                ? Colors.orange.withValues(alpha: 0.10)
                : Colors.green.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icono,
            color: cantidad == 0
                ? Colors.red
                : cantidad <= 10
                    ? Colors.orange
                    : Colors.green,
          ),

          const SizedBox(width: 12),

          Text(
            texto,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cantidad == 0
                  ? Colors.red
                  : cantidad <= 10
                      ? Colors.orange
                      : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
