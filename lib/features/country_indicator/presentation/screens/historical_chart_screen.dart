import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/countries.dart';
import '../../../../core/constants/indicators.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/indicator_data_point.dart';
import '../providers/country_indicator_providers.dart';
import '../widgets/indicator_chips.dart';
import '../widgets/trend_line_chart_widget.dart';
import '../widgets/year_filter_chips.dart';

class HistoricalChartScreen extends ConsumerStatefulWidget {
  const HistoricalChartScreen({
    super.key,
    required this.country,
    required this.initialIndicator,
  });

  final CountryOption country;
  final IndicatorType initialIndicator;

  @override
  ConsumerState<HistoricalChartScreen> createState() =>
      _HistoricalChartScreenState();
}

class _HistoricalChartScreenState extends ConsumerState<HistoricalChartScreen> {
  late IndicatorType _indicator = widget.initialIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final period = ref.watch(historyPeriodProvider);
    final params = HistoricalParams(
      countryCode: widget.country.iso3,
      indicator: _indicator,
      period: period,
    );
    final series = ref.watch(historicalSeriesProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.country.flag} ${widget.country.name}'),
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            IndicatorChips(
              selected: _indicator,
              onSelected: (i) => setState(() => _indicator = i),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(_indicator.label, style: theme.textTheme.titleMedium),
                ),
                YearFilterChips(
                  selected: period,
                  onSelected: (p) =>
                      ref.read(historyPeriodProvider.notifier).state = p,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SurfaceCard(
              padding: const EdgeInsets.fromLTRB(8, 20, 16, 8),
              child: SizedBox(
                height: 320,
                child: series.when(
                  loading: () => const LoadingView(height: 320),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(historicalSeriesProvider(params)),
                  ),
                  data: (points) => TrendLineChartWidget(
                    points: points,
                    indicator: _indicator,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            series.maybeWhen(
              data: (points) => points.isEmpty
                  ? const SizedBox.shrink()
                  : _StatsRow(points: points, indicator: _indicator),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.points, required this.indicator});

  final List<IndicatorDataPoint> points;
  final IndicatorType indicator;

  @override
  Widget build(BuildContext context) {
    final last = points.last;
    final min = points.reduce((a, b) => a.value! <= b.value! ? a : b);
    final max = points.reduce((a, b) => a.value! >= b.value! ? a : b);

    return Row(
      children: [
        Expanded(child: _StatTile(title: 'Último', point: last, unit: indicator.unit)),
        const SizedBox(width: 12),
        Expanded(child: _StatTile(title: 'Mínimo', point: min, unit: indicator.unit)),
        const SizedBox(width: 12),
        Expanded(child: _StatTile(title: 'Máximo', point: max, unit: indicator.unit)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.title, required this.point, required this.unit});

  final String title;
  final IndicatorDataPoint point;
  final IndicatorUnit unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelSmall?.copyWith(color: muted)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              NumberFormatter.byUnit(unit, point.value),
              style: theme.textTheme.titleMedium,
            ),
          ),
          Text('${point.year}', style: theme.textTheme.labelSmall?.copyWith(color: muted)),
        ],
      ),
    );
  }
}
