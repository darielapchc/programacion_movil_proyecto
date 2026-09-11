import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_principal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final keyForm = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!keyForm.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await AuthService().login(email.text.trim(), password.text);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.statusCode == 401
                  ? 'Correo o contraseña incorrectos.'
                  : e.message,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F5F0),
    appBar: AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      title: const Text('Iniciar Sesión'),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/logo.png', width: 150, height: 100),
                const Text(
                  'Bienvenido',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 35),
                CampoTexto(
                  label: 'Correo electrónico',
                  icono: Icons.email,
                  controlador: email,
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Ingrese un correo válido'
                      : null,
                ),
                const SizedBox(height: 20),
                CampoTexto(
                  label: 'Contraseña',
                  icono: Icons.lock,
                  controlador: password,
                  esPassword: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese la contraseña' : null,
                ),
                const SizedBox(height: 35),
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : BotonPrincipal(texto: 'Ingresar', onPressed: login),
                const SizedBox(height: 25),
                const Text(
                  'Solo personal autorizado',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
