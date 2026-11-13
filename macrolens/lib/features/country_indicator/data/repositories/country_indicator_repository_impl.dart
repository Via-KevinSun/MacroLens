import '../../../../core/constants/indicators.dart';
import '../../domain/entities/indicator_data_point.dart';
import '../../domain/repositories/country_indicator_repository.dart';
import '../datasources/world_bank_remote_data_source.dart';

class CountryIndicatorRepositoryImpl implements CountryIndicatorRepository {
  const CountryIndicatorRepositoryImpl(this._remote);
  final WorldBankRemoteDataSource _remote;

  @override
  Future<List<IndicatorDataPoint>> getIndicatorSeries(
    String countryCode,
    IndicatorType indicator,
  ) async {
    final models = await _remote.fetchIndicator(countryCode, indicator.id);
    return models.map((m) => m.toEntity()).toList();
  }
}
