import 'package:equatable/equatable.dart';

import '../../../../core/constants/indicators.dart';

class IndicatorSnapshot extends Equatable {
  const IndicatorSnapshot({
    required this.indicator,
    required this.year,
    required this.value,
    this.changePercent,
  });

  final IndicatorType indicator;
  final int? year;
  final double? value;

  /// Variação face ao ano anterior: % relativa (ou p.p. se o indicador já é %).
  final double? changePercent;

  @override
  List<Object?> get props => [indicator, year, value, changePercent];
}

class CountryProfile extends Equatable {
  const CountryProfile({required this.countryCode, required this.snapshots});
  final String countryCode;
  final Map<IndicatorType, IndicatorSnapshot> snapshots;

  @override
  List<Object?> get props => [countryCode, snapshots];
}
