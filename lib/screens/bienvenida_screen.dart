import 'package:flutter/material.dart';
import 'package:inventario_application_1/utils/app_colors.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compacto = constraints.maxHeight < 600;
            final double anchoContenido = constraints.maxWidth
                .clamp(0.0, 520.0)
                .toDouble();
            final double tamanoLogo = constraints.maxWidth < 360 ? 120 : 150;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 600 ? 24 : 40,
                vertical: compacto ? 16 : 30,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - (compacto ? 32 : 60))
                      .clamp(0.0, double.infinity)
                      .toDouble(),
                ),
                child: Center(
                  child: SizedBox(
                    width: anchoContenido,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: tamanoLogo,
                          height: tamanoLogo * .67,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: compacto ? 12 : 25),
                        Text(
                          'LNE Stock',
                          style: TextStyle(
                            fontSize: constraints.maxWidth < 360 ? 30 : 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Control de Inventario',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: constraints.maxWidth < 360 ? 18 : 22,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: compacto ? 18 : 35),
                        Text(
                          'Inventario de Libreria Y Novedades Emanuel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: constraints.maxWidth < 360 ? 14 : 16,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: compacto ? 24 : 50),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Ingresar',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: compacto ? 18 : 30),
                        const Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.verified_user, color: Colors.blueGrey),
                            SizedBox(width: 8),
                            Text(
                              'Solo personal autorizado',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
