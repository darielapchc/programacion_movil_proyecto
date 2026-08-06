import 'package:flutter/material.dart';
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
        home: const BienvenidaScreen(),
    );
  }
}

