/// Configuración central de la API.
/// Android Emulator: 10.0.2.2 apunta a la computadora anfitriona.
/// Dispositivo físico: reemplazar por la IP local de la computadora.
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const int lowStockThreshold = 10;
}
