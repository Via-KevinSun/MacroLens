import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/indicators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/indicator_data_point.dart';
import 'chart_axis.dart';

class TrendLineChartWidget extends StatelessWidget {
  const TrendLineChartWidget({
    super.key,
    required this.points,
    required this.indicator,
    this.color = AppColors.chartA,
  });

  /// Pontos sem nulls, em ordem cronológica crescente.
  final List<IndicatorDataPoint> points;
  final IndicatorType indicator;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const Center(child: Text('Dados insuficientes para o gráfico.'));
    }

    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );
    final spots = [
      for (final p in points) FlSpot(p.year.toDouble(), p.value!),
    ];

    return LineChart(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      LineChartData(
        minX: points.first.year.toDouble(),
        maxX: points.last.year.toDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: buildChartTitles(
          style: labelStyle,
          minYear: points.first.year,
          maxYear: points.last.year,
          unit: indicator.unit,
        ),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => theme.colorScheme.inverseSurface,
            getTooltipItems: (touched) => [
              for (final s in touched)
                LineTooltipItem(
                  '${s.x.toInt()}\n${NumberFormatter.tooltip(indicator.unit, s.y)}',
                  TextStyle(
                    color: theme.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.35),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
