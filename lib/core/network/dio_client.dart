import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'api_exception.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.timeout,
        receiveTimeout: ApiConstants.timeout,
        responseType: ResponseType.json,
        queryParameters: const {'format': 'json'},
      ),
    );
    dio.interceptors.add(_ErrorInterceptor());
    return dio;
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ApiException mapped;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        mapped = const ApiException('Tempo de ligação esgotado. Tente novamente.');
      case DioExceptionType.connectionError:
        mapped = const ApiException('Sem ligação à internet.');
      case DioExceptionType.badResponse:
        mapped = ApiException(
          'Erro do servidor (${err.response?.statusCode}).',
          statusCode: err.response?.statusCode,
        );
      default:
        mapped = const ApiException('Erro inesperado de rede.');
    }
    handler.reject(err.copyWith(error: mapped));
  }
}
