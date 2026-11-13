import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../country_indicator/domain/entities/indicator_data_point.dart';
import '../../../country_indicator/presentation/widgets/country_dropdown.dart';
import '../../../country_indicator/presentation/widgets/indicator_chips.dart';
import '../../../country_indicator/presentation/widgets/year_filter_chips.dart';
import '../../domain/entities/comparison_result.dart';
import '../providers/comparison_providers.dart';
import '../widgets/comparison_row.dart';
import '../widgets/dual_line_chart_widget.dart';

class CountryComparisonScreen extends ConsumerWidget {
  const CountryComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(comparisonCountryAProvider);
    final b = ref.watch(comparisonCountryBProvider);
    final indicator = ref.watch(comparisonIndicatorProvider);
    final period = ref.watch(comparisonPeriodProvider);
    final result = ref.watch(comparisonResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar países'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: CountryDropdown(
                    label: 'País A',
                    value: a,
                    onChanged: (c) =>
                        ref.read(comparisonCountryAProvider.notifier).state = c,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('vs'),
                ),
                Expanded(
                  child: CountryDropdown(
                    label: 'País B',
                    value: b,
                    onChanged: (c) =>
                        ref.read(comparisonCountryBProvider.notifier).state = c,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IndicatorChips(
              selected: indicator,
              onSelected: (i) =>
                  ref.read(comparisonIndicatorProvider.notifier).state = i,
            ),
            const SizedBox(height: 12),
            YearFilterChips(
              selected: period,
              onSelected: (p) =>
                  ref.read(comparisonPeriodProvider.notifier).state = p,
            ),
            const SizedBox(height: 16),
            result.when(
              loading: () => const LoadingView(height: 340),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(comparisonResultProvider),
              ),
              data: (r) => Column(
                children: [
                  SurfaceCard(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: SizedBox(
                      height: 340,
                      child: DualLineChartWidget(
                        seriesA: r.seriesA,
                        seriesB: r.seriesB,
                        labelA: a.iso3,
                        labelB: b.iso3,
                        indicator: indicator,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SummaryTable(result: r, labelA: a.iso3, labelB: b.iso3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTable extends StatelessWidget {
  const _SummaryTable({
    required this.result,
    required this.labelA,
    required this.labelB,
  });

  final ComparisonResult result;
  final String labelA;
  final String labelB;

  String _latest(IndicatorDataPoint? p) => p == null
      ? NumberFormatter.placeholder
      : '${NumberFormatter.byUnit(result.indicator.unit, p.value)}\n${p.year}';

  @override
  Widget build(BuildContext context) {
    final unit = result.indicator.unit;
    return SurfaceCard(
      child: Column(
        children: [
          ComparisonHeader(
            labelA: labelA,
            labelB: labelB,
            colorA: AppColors.chartA,
            colorB: AppColors.chartB,
          ),
          const Divider(height: 20),
          ComparisonRow(
            label: 'Último valor',
            valueA: _latest(result.latestA),
            valueB: _latest(result.latestB),
          ),
          ComparisonRow(
            label: 'Média do período',
            valueA: NumberFormatter.byUnit(unit, result.averageA),
            valueB: NumberFormatter.byUnit(unit, result.averageB),
          ),
          const Divider(height: 20),
          ComparisonDiffRow(
            label: 'Diferença das médias ($labelA vs $labelB)',
            percent: result.averageDifferencePercent,
          ),
        ],
      ),
    );
  }
}
