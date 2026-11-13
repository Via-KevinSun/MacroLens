import '../../../../core/constants/indicators.dart';
import '../entities/indicator_data_point.dart';

abstract class CountryIndicatorRepository {
  /// Série bruta tal como a API devolve (ordem decrescente, pode conter nulls).
  /// Lança [ApiException] em caso de falha.
  Future<List<IndicatorDataPoint>> getIndicatorSeries(
    String countryCode,
    IndicatorType indicator,
  );
}
