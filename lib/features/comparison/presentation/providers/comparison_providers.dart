import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/countries.dart';
import '../../../../core/constants/indicators.dart';
import '../../../country_indicator/domain/usecases/get_historical_indicator_usecase.dart';
import '../../../country_indicator/presentation/providers/country_indicator_providers.dart';
import '../../domain/entities/comparison_result.dart';
import '../../domain/usecases/compare_two_countries_usecase.dart';

final compareTwoCountriesUseCaseProvider = Provider<CompareTwoCountriesUseCase>(
  (ref) => CompareTwoCountriesUseCase(
    ref.watch(getHistoricalIndicatorUseCaseProvider),
  ),
);

final comparisonCountryAProvider =
    StateProvider<CountryOption>((ref) => Countries.byCode('MOZ')!);
final comparisonCountryBProvider =
    StateProvider<CountryOption>((ref) => Countries.byCode('BRA')!);
final comparisonIndicatorProvider =
    StateProvider<IndicatorType>((ref) => IndicatorType.gdpGrowth);
final comparisonPeriodProvider =
    StateProvider<HistoryPeriod>((ref) => HistoryPeriod.twentyYears);

final comparisonResultProvider = FutureProvider<ComparisonResult>((ref) {
  final a = ref.watch(comparisonCountryAProvider);
  final b = ref.watch(comparisonCountryBProvider);
  final indicator = ref.watch(comparisonIndicatorProvider);
  final period = ref.watch(comparisonPeriodProvider);
  return ref.watch(compareTwoCountriesUseCaseProvider)(
    a.iso3,
    b.iso3,
    indicator,
    period: period,
  );
});
