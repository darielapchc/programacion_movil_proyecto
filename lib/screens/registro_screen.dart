import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../widgets/boton_principal.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarContrasenaController = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarContrasenaController.dispose();
    super.dispose();
  }

  String? _obligatorio(String? value, String campo) {
    if (value == null || value.trim().isEmpty) {
      return '$campo es obligatorio';
    }
    return null;
  }

  String? _validarCorreo(String? value) {
    final obligatorio = _obligatorio(value, 'El correo electrónico');
    if (obligatorio != null) return obligatorio;

    final correoValido = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim());
    return correoValido ? null : 'Ingresa un correo electrónico válido';
  }

  String? _validarContrasena(String? value) {
    final obligatorio = _obligatorio(value, 'La contraseña');
    if (obligatorio != null) return obligatorio;
    if (value!.length < 8) return 'Debe tener mínimo 8 caracteres';
    if (!RegExp(r'\d').hasMatch(value)) return 'Debe contener al menos un número';
    return null;
  }

  String? _validarConfirmacion(String? value) {
    final obligatorio = _obligatorio(value, 'La confirmación de contraseña');
    if (obligatorio != null) return obligatorio;
    return value == _contrasenaController.text
        ? null
        : 'Las contraseñas no coinciden';
  }

  //Metodo crear cuenta
  Future<void> _crearCuenta() async {
  if (!(_formKey.currentState?.validate() ?? false)) {
    return;
  }
  if (_cargando) return;
  setState(() { _cargando = true;});

  final fullName = '${_nombreController.text.trim()} ' '${_apellidoController.text.trim()}';

  try {
    await AuthService().register( fullName: fullName, email: _correoController.text.trim(), password: _contrasenaController.text );

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Registro exitoso!'),
          content: const Text(
            'El usuario fue creado correctamente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        );
      },
    );
  } on ApiException catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar( content: Text(error.message)),
    );
  } catch (_) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ocurrió un error al crear el usuario.',
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }
}

  InputDecoration _decoracion(String label, IconData icono) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icono),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
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
        title: const Text('Crear usuario'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
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
                      'Crear usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _nombreController,
                      textInputAction: TextInputAction.next,
                      decoration: _decoracion('Nombre', Icons.person_outline),
                      validator: (value) => _obligatorio(value, 'El nombre'),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _apellidoController,
                      textInputAction: TextInputAction.next,
                      decoration: _decoracion('Apellido', Icons.person_outline),
                      validator: (value) => _obligatorio(value, 'El apellido'),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _decoracion('Correo electrónico', Icons.email_outlined),
                      validator: _validarCorreo,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _contrasenaController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: _decoracion('Contraseña', Icons.lock_outline),
                      validator: _validarContrasena,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _confirmarContrasenaController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: _decoracion('Confirmar contraseña', Icons.lock_outline),
                      validator: _validarConfirmacion,
                    ),
                    const SizedBox(height: 30),
                    BotonPrincipal(texto: 'Crear cuenta', onPressed: _crearCuenta),
                    const SizedBox(height: 24),
                    const Text(
                      '¿Ya tienes una cuenta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
