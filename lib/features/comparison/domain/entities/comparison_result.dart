import 'package:equatable/equatable.dart';

import '../../../../core/constants/indicators.dart';
import '../../../country_indicator/domain/entities/indicator_data_point.dart';

class ComparisonResult extends Equatable {
  const ComparisonResult({
    required this.indicator,
    required this.countryA,
    required this.countryB,
    required this.seriesA,
    required this.seriesB,
  });

  final IndicatorType indicator;
  final String countryA;
  final String countryB;

  /// Séries sem nulls, em ordem cronológica crescente.
  final List<IndicatorDataPoint> seriesA;
  final List<IndicatorDataPoint> seriesB;

  static double? _average(List<IndicatorDataPoint> s) {
    final values = s.map((p) => p.value).whereType<double>().toList();
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double? get averageA => _average(seriesA);
  double? get averageB => _average(seriesB);
  IndicatorDataPoint? get latestA => seriesA.isEmpty ? null : seriesA.last;
  IndicatorDataPoint? get latestB => seriesB.isEmpty ? null : seriesB.last;
  bool get hasData => seriesA.isNotEmpty || seriesB.isNotEmpty;

  /// Diferença percentual da média de A face à média de B.
  double? get averageDifferencePercent {
    final a = averageA;
    final b = averageB;
    if (a == null || b == null || b == 0) return null;
    return (a - b) / b.abs() * 100;
  }

  @override
  List<Object?> get props => [indicator, countryA, countryB, seriesA, seriesB];
}
