import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  // No site (web) usa o intermediário do Cloudflare; no Android liga direto.
  static const String _webProxy =
      'https://macrolens-proxy.kevinsalvadordeanianos.workers.dev/';

  static String get baseUrl =>
      kIsWeb ? _webProxy : 'https://api.worldbank.org/v2';

  static const int perPage = 100;
  static const Duration timeout = Duration(seconds: 15);

  static String indicatorPath(String countryCode, String indicatorId) =>
      '/country/$countryCode/indicator/$indicatorId';
}