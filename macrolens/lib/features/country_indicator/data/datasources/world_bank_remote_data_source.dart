import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../models/world_bank_indicator_model.dart';

class WorldBankRemoteDataSource {
  const WorldBankRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<WorldBankIndicatorModel>> fetchIndicator(
    String countryCode,
    String indicatorId,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.indicatorPath(countryCode, indicatorId),
        queryParameters: {'per_page': ApiConstants.perPage},
      );
      return _parse(response.data);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException('Falha ao obter dados do Banco Mundial.');
    }
  }

  /// A resposta é um array de 2 posições:
  /// [0] = metadados de paginação | [1] = registos por ano.
  /// Erros da API chegam com HTTP 200 e [0] = {"message": [...]}.
  List<WorldBankIndicatorModel> _parse(dynamic data) {
    if (data is! List || data.isEmpty) {
      throw const ApiException('Resposta inválida do Banco Mundial.');
    }
    final meta = data[0];
    if (meta is Map && meta.containsKey('message')) {
      throw const ApiException('País ou indicador inválido.');
    }
    if (data.length < 2 || data[1] == null) return const [];

    return (data[1] as List)
        .whereType<Map<String, dynamic>>()
        .map(WorldBankIndicatorModel.fromJson)
        .toList();
  }
}
