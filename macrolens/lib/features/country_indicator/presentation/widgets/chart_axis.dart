import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/indicators.dart';
import '../../../../core/utils/number_formatter.dart';

String _yLabel(IndicatorUnit unit, double v) => switch (unit) {
      IndicatorUnit.percent => '${v.toStringAsFixed(0)}%',
      IndicatorUnit.years => v.toStringAsFixed(0),
      _ => NumberFormatter.compact(v, decimals: 1),
    };

/// Eixos partilhados pelos gráficos de linha (anos em baixo, valores à esquerda).
FlTitlesData buildChartTitles({
  required TextStyle? style,
  required int minYear,
  required int maxYear,
  required IndicatorUnit unit,
}) {
  final interval = math.max(1, ((maxYear - minYear) / 5).ceil()).toDouble();
  const hidden = AxisTitles(sideTitles: SideTitles(showTitles: false));

  return FlTitlesData(
    topTitles: hidden,
    rightTitles: hidden,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: interval,
        getTitlesWidget: (value, meta) {
          if (value % 1 != 0 || (value - minYear) % interval != 0) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(value.toInt().toString(), style: style),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 56,
        getTitlesWidget: (value, meta) => SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(_yLabel(unit, value), style: style),
        ),
      ),
    ),
  );
}
