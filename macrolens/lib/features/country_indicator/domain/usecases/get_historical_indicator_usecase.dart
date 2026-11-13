import '../../../../core/constants/indicators.dart';
import '../entities/indicator_data_point.dart';
import '../repositories/country_indicator_repository.dart';

enum HistoryPeriod {
  tenYears('10A', 10),
  twentyYears('20A', 20),
  all('Tudo', null);

  const HistoryPeriod(this.label, this.years);
  final String label;
  final int? years;
}

class GetHistoricalIndicatorUseCase {
  const GetHistoricalIndicatorUseCase(this._repository);
  final CountryIndicatorRepository _repository;

  /// Devolve pontos sem nulls, em ordem cronológica CRESCENTE.
  Future<List<IndicatorDataPoint>> call(
    String countryCode,
    IndicatorType indicator, {
    HistoryPeriod period = HistoryPeriod.twentyYears,
  }) async {
    final raw = await _repository.getIndicatorSeries(countryCode, indicator);

    final cleaned = raw.where((p) => p.value != null).toList()
      ..sort((a, b) => a.year.compareTo(b.year));

    final years = period.years;
    if (years == null || cleaned.isEmpty) return cleaned;

    final minYear = cleaned.last.year - years + 1;
    return cleaned.where((p) => p.year >= minYear).toList();
  }
}
