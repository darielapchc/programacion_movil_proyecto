import 'package:flutter/material.dart';

class BotonPrincipal extends StatelessWidget {

  final String texto;
  final VoidCallback onPressed;

  const BotonPrincipal({
    super.key, 
    required this.texto, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:  Color(0xFF8B5E00), 
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
      ),
      ),
    );
  }
}