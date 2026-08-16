import 'package:flutter/material.dart';
import 'package:inventario_application_1/screens/agregar_producto_screen.dart';
import 'package:inventario_application_1/screens/categoria_screen.dart';
import 'package:inventario_application_1/screens/detalle_producto_screen.dart';
import 'package:inventario_application_1/screens/estadisticas_screen.dart';
import 'package:inventario_application_1/screens/home_screen.dart';
import 'package:inventario_application_1/screens/inventario_screen.dart';
import 'package:inventario_application_1/screens/login_screen.dart';
import 'package:inventario_application_1/screens/perfil_screen.dart';
import 'screens/bienvenida_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LNE Stock",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: '/bienvenida',

      routes: {
        '/bienvenida':(context) => const BienvenidaScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/inventario': (context) => const InventarioScreen(),
        '/categorias':(context) => const CategoriasScreen(),
        '/agregar-producto':(context) => const AgregarProductoScreen(),
        '/detalle':(context) => const DetalleProductoScreen(),
        '/perfil':(context) => const PerfilScreen(),
        '/estadisticas':(context) => const EstadisticasScreen(),
      },
    );
  }
}

