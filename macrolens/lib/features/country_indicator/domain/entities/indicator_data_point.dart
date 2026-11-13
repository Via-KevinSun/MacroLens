import 'package:equatable/equatable.dart';

class IndicatorDataPoint extends Equatable {
  const IndicatorDataPoint({required this.year, required this.value});
  final int year;
  final double? value;

  @override
  List<Object?> get props => [year, value];
}
