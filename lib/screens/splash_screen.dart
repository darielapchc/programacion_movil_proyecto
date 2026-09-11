import 'package:flutter/material.dart';
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
    _restore();
  }

  Future<void> _restore() async {
    final user = await AuthService().restoreSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      user == null ? '/bienvenida' : '/home',
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logoApp.png', width: 160),
          const SizedBox(height: 20),
          const CircularProgressIndicator(color: AppColors.primary),
        ],
      ),
    ),
  );
}
