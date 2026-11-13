import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  // No site (web) o pedido vai para o próprio Render (/wb), que reencaminha
  // para o Banco Mundial e evita o bloqueio CORS do navegador.
  // No Android (APK) liga-se direto, sem problema.
  static String get baseUrl =>
      kIsWeb ? '${Uri.base.origin}/wb' : 'https://api.worldbank.org/v2';

  static const int perPage = 100;
  static const Duration timeout = Duration(seconds: 15);

  static String indicatorPath(String countryCode, String indicatorId) =>
      '/country/$countryCode/indicator/$indicatorId';
}