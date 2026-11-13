import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/countries.dart';
import '../../../../core/constants/indicators.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/world_bank_remote_data_source.dart';
import '../../data/repositories/country_indicator_repository_impl.dart';
import '../../domain/entities/country_profile.dart';
import '../../domain/entities/indicator_data_point.dart';
import '../../domain/repositories/country_indicator_repository.dart';
import '../../domain/usecases/get_country_overview_usecase.dart';
import '../../domain/usecases/get_historical_indicator_usecase.dart';

// ---------- Injeção de dependências ----------
final dioProvider = Provider<Dio>((ref) => DioClient.create());

final remoteDataSourceProvider = Provider<WorldBankRemoteDataSource>(
  (ref) => WorldBankRemoteDataSource(ref.watch(dioProvider)),
);

final countryIndicatorRepositoryProvider = Provider<CountryIndicatorRepository>(
  (ref) => CountryIndicatorRepositoryImpl(ref.watch(remoteDataSourceProvider)),
);

final getHistoricalIndicatorUseCaseProvider =
    Provider<GetHistoricalIndicatorUseCase>(
  (ref) => GetHistoricalIndicatorUseCase(
    ref.watch(countryIndicatorRepositoryProvider),
  ),
);

final getCountryOverviewUseCaseProvider = Provider<GetCountryOverviewUseCase>(
  (ref) => GetCountryOverviewUseCase(
    ref.watch(countryIndicatorRepositoryProvider),
  ),
);

// ---------- Estado de UI ----------
final selectedCountryProvider =
    StateProvider<CountryOption>((ref) => Countries.all.first);

final countrySearchQueryProvider = StateProvider<String>((ref) => '');

final historyPeriodProvider =
    StateProvider<HistoryPeriod>((ref) => HistoryPeriod.twentyYears);

// ---------- Dados assíncronos (AsyncValue) ----------
final countryOverviewProvider =
    FutureProvider.family<CountryProfile, String>((ref, countryCode) {
  return ref.watch(getCountryOverviewUseCaseProvider)(countryCode);
});

class HistoricalParams extends Equatable {
  const HistoricalParams({
    required this.countryCode,
    required this.indicator,
    required this.period,
  });

  final String countryCode;
  final IndicatorType indicator;
  final HistoryPeriod period;

  @override
  List<Object?> get props => [countryCode, indicator, period];
}

final historicalSeriesProvider =
    FutureProvider.family<List<IndicatorDataPoint>, HistoricalParams>(
  (ref, params) {
    return ref.watch(getHistoricalIndicatorUseCaseProvider)(
      params.countryCode,
      params.indicator,
      period: params.period,
    );
  },
);
