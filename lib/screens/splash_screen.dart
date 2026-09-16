import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../services/auth_service.dart';
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
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    // Pequeña pausa para mostrar el Splash de forma agradable al usuario.
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    // Buscamos el token guardado en el dispositivo.
    final token = await ApiClient.instance.storage.getToken();
    // Si no existe token, el usuario debe iniciar sesión.
    if (token == null || token.isEmpty) {
      _irA('/bienvenida');
      return;
    }

    try {
      // Verificamos que el token siga siendo válido consultando al usuario autenticado.
      await AuthService().me();

      // Token válido: entramos directamente al Home.
      if (!mounted) return;
      _irA('/home');
    } catch (_) {
      // Token inválido, expirado o sesión no disponible. Limpiamos el token para evitar intentar reutilizarlo.
      await ApiClient.instance.storage.clearToken();
      if (!mounted) return;
      _irA('/bienvenida');
    }
  }

  void _irA(String ruta) {
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      ruta,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double anchoLogo =
        MediaQuery.sizeOf(context).width.clamp(110.0, 180.0);

    return Scaffold(
      backgroundColor: Colors.white,
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