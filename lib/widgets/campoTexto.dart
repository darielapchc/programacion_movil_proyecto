import 'package:flutter/material.dart';

class campoTexto extends StatelessWidget {

  final String label; 
  final IconData icono; 
  final bool esPassword; 
  final TextEditingController controlador; 

  const campoTexto({
    super.key, 
    required this.label,
    required this.icono,  
    required this.esPassword,
    required this.controlador,
    });

    @override 
    Widget build(BuildContext context) {
      return TextFormField(
        controller: controlador, 
        obscureText: esPassword, 
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