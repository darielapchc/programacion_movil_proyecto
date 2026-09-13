import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  Usuario? _usuario;
  bool _cargando = true;
  bool _guardando = false;
  bool _editando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _cargarPerfil() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final usuario = await _authService.me();
      if (!mounted) return;
      setState(() {
        _usuario = usuario;
        _nombreController.text = usuario.fullName;
        _correoController.text = usuario.email;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudo cargar el perfil.';
      });
    }
  }

  void _iniciarEdicion() {
    final usuario = _usuario;
    if (usuario == null) return;
    _nombreController.text = usuario.fullName;
    _correoController.text = usuario.email;
    setState(() => _editando = true);
  }

  Future<void> _guardarPerfil() async {
    if (!_formKey.currentState!.validate() || _guardando) return;

    setState(() => _guardando = true);
    try {
      final usuario = await _authService.updateMe(
        fullName: _nombreController.text.trim(),
        email: _correoController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _usuario = usuario;
        _editando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo actualizar el perfil. Intenta nuevamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _cargarPerfil,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final usuario = _usuario!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _editando ? _buildEditView(usuario) : _buildProfileView(usuario),
    );
  }

  Widget _buildProfileView(Usuario usuario) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 55,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 15),
        Text(
          usuario.fullName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          usuario.role,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 30),
        _seccionTitulo('Información personal', Icons.person_outline),
        const SizedBox(height: 10),
        _informacionCard(
          icono: Icons.person,
          titulo: 'Nombre',
          valor: usuario.fullName,
        ),
        _informacionCard(
          icono: Icons.email_outlined,
          titulo: 'Correo electrónico',
          valor: usuario.email,
        ),
        _informacionCard(
          icono: Icons.badge_outlined,
          titulo: 'Rol',
          valor: usuario.role,
        ),
        const SizedBox(height: 25),
        _seccionTitulo('Opciones', Icons.settings_outlined),
        const SizedBox(height: 10),
        _opcionCard(
          icono: Icons.edit,
          titulo: 'Editar perfil',
          onTap: _iniciarEdicion,
        ),
        _opcionCard(
          icono: Icons.settings,
          titulo: 'Configuración',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Configuración próximamente')),
            );
          },
        ),
        _opcionCard(
          icono: Icons.info_outline,
          titulo: 'Acerca de LNE Stock',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'LNE Stock',
              applicationVersion: '1.0.0',
              applicationLegalese:
                  'Sistema de inventario de Librería y Novedades Emanuel',
            );
          },
        ),
        const SizedBox(height: 20),
        _buildLogoutButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEditView(Usuario usuario) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 30),
          _seccionTitulo('Información personal', Icons.person_outline),
          const SizedBox(height: 10),
          TextFormField(
            controller: _nombreController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration('Nombre', Icons.person),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa tu nombre.';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _correoController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              'Correo electrónico',
              Icons.email_outlined,
            ),
            validator: (value) {
              final correo = value?.trim() ?? '';
              final esValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                  .hasMatch(correo);
              if (!esValido) return 'Ingresa un correo válido.';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _informacionCard(
            icono: Icons.badge_outlined,
            titulo: 'Rol',
            valor: usuario.role,
          ),
          const SizedBox(height: 20),
          _guardando
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _guardarPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
          TextButton(
            onPressed: _guardando
                ? null
                : () => setState(() => _editando = false),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _mostrarCerrarSesion(context),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Cerrar sesión',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _seccionTitulo(String titulo, IconData icono) {
    return Row(
      children: [
        Icon(icono, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _informacionCard({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: Icon(icono, color: AppColors.primary),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _opcionCard({
    required IconData icono,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icono, color: AppColors.primary),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  void _mostrarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás segura de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _authService.logout();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/bienvenida',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }
}
