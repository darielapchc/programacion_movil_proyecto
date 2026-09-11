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
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        // Navega a Bienvenida y elimina la Splash del historial
        Navigator.pushReplacementNamed(context, '/bienvenida');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double anchoLogo = MediaQuery.sizeOf(context).width.clamp(110.0, 180.0);
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio para resaltar el logo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Image.asset(
                'assets/images/logoApp.png',
                width: anchoLogo,
                height: anchoLogo * 0.67,
              ),           
              const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
