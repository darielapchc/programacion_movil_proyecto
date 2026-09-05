import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Lógica para navegar automáticamente después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Navega a Bienvenida y elimina la Splash del historial
        Navigator.pushReplacementNamed(context, '/bienvenida');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio para resaltar el logo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reutilizamos tu logo que ya tienes en Bienvenida
            Image.asset(
              'assets/images/logo.png',
              width: 180, // Un poco más grande
              height: 120,
            ),
            const SizedBox(height: 20),
            // Opcional: Un indicador de carga discreto
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}