import 'package:flutter/material.dart';
import 'package:inventario_application_1/screens/home_screen.dart';
import 'package:inventario_application_1/widgets/campotexto.dart';
import 'package:inventario_application_1/widgets/boton_principal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Llave del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable para mostrar u ocultar contraseña
  bool ocultarPassword = true;

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),

      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5E00),
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
                  const Icon(
                    Icons.inventory_2,
                    size: 100,
                    color: Color(0xFF8B5E00),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Bienvenido",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "LNE Stock",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
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
                  BotonPrincipal(
                    texto: "Ingresar",
                    onPressed: iniciarSesion,
                  ),
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