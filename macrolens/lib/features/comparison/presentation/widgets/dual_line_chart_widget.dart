import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/indicators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../country_indicator/domain/entities/indicator_data_point.dart';
import '../../../country_indicator/presentation/widgets/chart_axis.dart';

class _Bar {
  const _Bar(this.label, this.color, this.points);
  final String label;
  final Color color;
  final List<IndicatorDataPoint> points;
}

class DualLineChartWidget extends StatelessWidget {
  const DualLineChartWidget({
    super.key,
    required this.seriesA,
    required this.seriesB,
    required this.labelA,
    required this.labelB,
    required this.indicator,
    this.colorA = AppColors.chartA,
    this.colorB = AppColors.chartB,
  });

  final List<IndicatorDataPoint> seriesA;
  final List<IndicatorDataPoint> seriesB;
  final String labelA;
  final String labelB;
  final IndicatorType indicator;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    final bars = <_Bar>[
      if (seriesA.isNotEmpty) _Bar(labelA, colorA, seriesA),
      if (seriesB.isNotEmpty) _Bar(labelB, colorB, seriesB),
    ];
    if (bars.isEmpty) {
      return const Center(child: Text('Sem dados para este indicador.'));
    }

    final years = bars.expand((b) => b.points.map((p) => p.year)).toList();
    final minYear = years.reduce((a, b) => a < b ? a : b);
    final maxYear = years.reduce((a, b) => a > b ? a : b);
    if (minYear == maxYear) {
      return const Center(child: Text('Dados insuficientes para o gráfico.'));
    }

    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(
              color: colorA,
              text: seriesA.isEmpty ? '$labelA (sem dados)' : labelA,
            ),
            const SizedBox(width: 20),
            _LegendItem(
              color: colorB,
              text: seriesB.isEmpty ? '$labelB (sem dados)' : labelB,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            LineChartData(
              minX: minYear.toDouble(),
              maxX: maxYear.toDouble(),
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
                minYear: minYear,
                maxYear: maxYear,
                unit: indicator.unit,
              ),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                  getTooltipItems: (touched) => [
                    for (final s in touched)
                      LineTooltipItem(
                        '${s.x.toInt()} · ${bars[s.barIndex].label}\n'
                        '${NumberFormatter.tooltip(indicator.unit, s.y)}',
                        TextStyle(
                          color: bars[s.barIndex].color,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              lineBarsData: [
                for (final bar in bars)
                  LineChartBarData(
                    spots: [
                      for (final p in bar.points)
                        FlSpot(p.year.toDouble(), p.value!),
                    ],
                    isCurved: true,
                    color: bar.color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
