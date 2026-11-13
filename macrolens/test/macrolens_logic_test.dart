import 'package:flutter_test/flutter_test.dart';
import 'package:macrolens/core/constants/indicators.dart';
import 'package:macrolens/core/utils/number_formatter.dart';
import 'package:macrolens/features/country_indicator/domain/entities/indicator_data_point.dart';
import 'package:macrolens/features/country_indicator/domain/repositories/country_indicator_repository.dart';
import 'package:macrolens/features/country_indicator/domain/usecases/get_historical_indicator_usecase.dart';

class _FakeRepo implements CountryIndicatorRepository {
  @override
  Future<List<IndicatorDataPoint>> getIndicatorSeries(
    String countryCode,
    IndicatorType indicator,
  ) async =>
      const [
        IndicatorDataPoint(year: 2022, value: 3),
        IndicatorDataPoint(year: 2021, value: null),
        IndicatorDataPoint(year: 2020, value: 1),
      ];
}

void main() {
  test('NumberFormatter abrevia valores grandes', () {
    expect(NumberFormatter.compact(2.08e12), '2.08T');
    expect(NumberFormatter.compact(1500, decimals: 1), '1.5K');
    expect(NumberFormatter.compact(null), '—');
    expect(NumberFormatter.currencyLong(2.08e12), '\$ 2.08 Trilhões');
  });

  test('use case remove nulls e ordena do mais antigo ao mais recente', () async {
    final useCase = GetHistoricalIndicatorUseCase(_FakeRepo());
    final result = await useCase('MOZ', IndicatorType.gdp, period: HistoryPeriod.all);
    expect(result.map((p) => p.year).toList(), [2020, 2022]);
  });
}
