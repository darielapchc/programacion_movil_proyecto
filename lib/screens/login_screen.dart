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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> iniciarSesion() async {
    if (!_formKey.currentState!.validate() || _cargando) return;
    setState(() => _cargando = true);
    try {
      await AuthService().login(usuarioController.text.trim(), passwordController.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on ApiException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double anchoLogo = MediaQuery.sizeOf(context).width.clamp(110.0, 180.0);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Iniciar Sesión"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Image.asset(
                'assets/images/logo.png',
                width: anchoLogo,
                height: anchoLogo * 0.67,
              ),
                  const SizedBox(height: 15),
                  const Text(
                    "Bienvenido",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "LNE Stock",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 35),
                  CampoTexto(
                    label: "Usuario",
                    icono: Icons.person,
                    controlador: usuarioController,
                    esPassword: false,
                  ),
                  const SizedBox(height: 20),
                  CampoTexto(
                    label: "Contraseña",
                    icono: Icons.lock,
                    controlador: passwordController,
                    esPassword: true,
                  ),
                  const SizedBox(height: 35),
                  _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : BotonPrincipal(texto: "Ingresar", onPressed: iniciarSesion),
                  const SizedBox(height: 25),
                  const Text(
                    "Solo personal autorizado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
