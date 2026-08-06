import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String label;
  final IconData icono;
  final bool esPassword;
  final TextEditingController controlador;
  final String? Function(String?)? validator;

  const CampoTexto({
    super.key,
    required this.label,
    required this.icono,
    required this.controlador,
    this.esPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: esPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}