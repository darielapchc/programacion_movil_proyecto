import 'package:flutter/material.dart';

class SnackBarHelper {
  static void mostrarConAccion(
    BuildContext context, {
    required String mensaje,
    required VoidCallback onVer,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        action: SnackBarAction(
          label: 'VER',
          onPressed: onVer,
        ),
      ),
    );
  }
  static void mostrarFlotante(
    BuildContext context, {
    required String mensaje,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}