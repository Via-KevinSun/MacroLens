import '../../../../core/constants/indicators.dart';
import '../../../country_indicator/domain/usecases/get_historical_indicator_usecase.dart';
import '../entities/comparison_result.dart';

class CompareTwoCountriesUseCase {
  const CompareTwoCountriesUseCase(this._getHistorical);
  final GetHistoricalIndicatorUseCase _getHistorical;

  Future<ComparisonResult> call(
    String countryA,
    String countryB,
    IndicatorType indicator, {
    HistoryPeriod period = HistoryPeriod.twentyYears,
  }) async {
    final results = await Future.wait([
      _getHistorical(countryA, indicator, period: period),
      _getHistorical(countryB, indicator, period: period),
    ]);
    return ComparisonResult(
      indicator: indicator,
      countryA: countryA,
      countryB: countryB,
      seriesA: results[0],
      seriesB: results[1],
    );
  }
}
