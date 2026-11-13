import '../../../../core/constants/indicators.dart';
import '../entities/country_profile.dart';
import '../repositories/country_indicator_repository.dart';

class GetCountryOverviewUseCase {
  const GetCountryOverviewUseCase(this._repository);
  final CountryIndicatorRepository _repository;

  static const _dashboardIndicators = [
    IndicatorType.gdp,
    IndicatorType.gdpGrowth,
    IndicatorType.inflation,
    IndicatorType.population,
  ];

  Future<CountryProfile> call(String countryCode) async {
    final results = await Future.wait(
      _dashboardIndicators.map((i) => _snapshot(countryCode, i)),
    );
    return CountryProfile(
      countryCode: countryCode,
      snapshots: {for (final s in results) s.indicator: s},
    );
  }

  Future<IndicatorSnapshot> _snapshot(String code, IndicatorType ind) async {
    final raw = await _repository.getIndicatorSeries(code, ind);
    final valid = raw.where((p) => p.value != null).toList()
      ..sort((a, b) => b.year.compareTo(a.year));

    if (valid.isEmpty) {
      return IndicatorSnapshot(indicator: ind, year: null, value: null);
    }
    final latest = valid.first;
    double? change;
    if (valid.length > 1) {
      final prev = valid[1].value!;
      if (ind.unit == IndicatorUnit.percent) {
        change = latest.value! - prev; // pontos percentuais
      } else if (prev != 0) {
        change = (latest.value! - prev) / prev.abs() * 100;
      }
    }
    return IndicatorSnapshot(
      indicator: ind,
      year: latest.year,
      value: latest.value,
      changePercent: change,
    );
  }
}
