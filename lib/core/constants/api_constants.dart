class ApiConstants {
  ApiConstants._();

  // HTTPS: o Android bloqueia HTTP simples por defeito (cleartext).
  static const String baseUrl = 'https://api.worldbank.org/v2';
  static const int perPage = 100;
  static const Duration timeout = Duration(seconds: 15);

  static String indicatorPath(String countryCode, String indicatorId) =>
      '/country/$countryCode/indicator/$indicatorId';
}
