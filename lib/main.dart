import 'package:flutter/material.dart';
import 'core/api_client.dart';
import 'package:inventario_application_1/screens/splash_screen.dart'; 
import 'package:inventario_application_1/screens/agregar_producto_screen.dart';
import 'package:inventario_application_1/models/producto.dart';
import 'package:inventario_application_1/screens/categoria_screen.dart';
import 'package:inventario_application_1/screens/detalle_producto_screen.dart';
import 'package:inventario_application_1/screens/estadisticas_screen.dart';
import 'package:inventario_application_1/screens/movimientos_screen.dart';
import 'package:inventario_application_1/screens/home_screen.dart';
import 'package:inventario_application_1/screens/inventario_screen.dart';
import 'package:inventario_application_1/screens/login_screen.dart';
import 'package:inventario_application_1/screens/perfil_screen.dart';
import 'package:inventario_application_1/screens/registro_screen.dart';
import 'screens/bienvenida_screen.dart';
import 'utils/app_colors.dart';
import 'services/notificacion_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await ApiClient.instance.initialize();

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
      initialRoute: '/', 

      routes: {
        '/': (context) => const SplashScreen(), 
        '/bienvenida': (context) => const BienvenidaScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/home': (context) => const HomeScreen(),
        '/inventario': (context) => const InventarioScreen(),
        '/categorias': (context) => const CategoriasScreen(),
        '/agregar-producto': (context) => AgregarProductoScreen(
              producto: ModalRoute.of(context)?.settings.arguments as Producto?,
            ),
        '/detalle': (context) => const DetalleProductoScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/estadisticas': (context) => const EstadisticasScreen(),
        '/movimientos': (context) => const MovimientosScreen(),
      },
    );
  }
}

//---- CREDENCIALES PARA INICIAR SESIÓN ---- //
/* 
  - fullName: 'Lia Jael', email: 'liajael@gmail.com', role: 'staff'
  - fullName: 'Administración LNE Stock', email: 'admin@lnestock.hn', role: 'admin' 
  
*/