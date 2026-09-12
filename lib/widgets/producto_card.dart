// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
  final String nombre, codigo, categoria;
  final double precio;
  final int cantidad;
  final bool mostrarEstado, esFavorito, mostrarFavorito;
  final Color colorAccento;
  final VoidCallback onTap, onFavorite;

  const ProductoCard({
    super.key,
    required this.nombre,
    required this.codigo,
    required this.cantidad,
    required this.categoria,
    required this.precio,
    required this.onTap,
    required this.onFavorite,
    required this.esFavorito,
    this.mostrarEstado = true,
    this.mostrarFavorito = true,
    this.colorAccento = Colors.brown,
  });

  @override
  Widget build(BuildContext context) {
    final bool agotado = cantidad == 0;
    final bool bajo = cantidad > 0 && cantidad <= 5;
    final String estado = agotado ? 'Agotado' : bajo ? 'Stock bajo' : 'Disponible';
    final Color estadoColor = agotado ? Colors.red : bajo ? Colors.orange : Colors.green;
    final IconData estadoIcon = agotado
        ? Icons.error_outline
        : bajo ? Icons.warning_amber_rounded : Icons.check_circle_outline;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: colorAccento.withOpacity(0.15),
                child: Icon(Icons.inventory_2, color: colorAccento),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Código: $codigo', maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('Categoría: $categoria', maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('Cantidad: $cantidad'),
                    Text('Precio: L. ${precio.toStringAsFixed(2)}'),
                    if (mostrarEstado)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: estadoColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            Icon(estadoIcon, size: 16, color: estadoColor),
                            Text(estado, style: TextStyle(color: estadoColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              if (mostrarFavorito)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Favorito',
                  icon: Icon(esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: esFavorito ? Colors.red : Colors.grey),
                  onPressed: onFavorite,
                ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
