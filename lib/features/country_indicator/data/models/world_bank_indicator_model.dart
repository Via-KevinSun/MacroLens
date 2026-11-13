import '../../domain/entities/indicator_data_point.dart';

class WorldBankIndicatorModel {
  const WorldBankIndicatorModel({
    required this.countryCode,
    required this.countryName,
    required this.year,
    required this.value,
  });

  final String countryCode;
  final String countryName;
  final int year;
  final double? value;

  factory WorldBankIndicatorModel.fromJson(Map<String, dynamic> json) {
    final country = (json['country'] as Map<String, dynamic>?) ?? const {};
    return WorldBankIndicatorModel(
      countryCode: (json['countryiso3code'] as String?) ??
          (country['id'] as String?) ??
          '',
      countryName: (country['value'] as String?) ?? '',
      year: int.tryParse('${json['date']}') ?? 0,
      value: (json['value'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'countryiso3code': countryCode,
        'country': {'value': countryName},
        'date': '$year',
        'value': value,
      };

  IndicatorDataPoint toEntity() => IndicatorDataPoint(year: year, value: value);
}
