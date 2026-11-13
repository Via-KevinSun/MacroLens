import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/countries.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../providers/country_indicator_providers.dart';
import '../widgets/indicator_metric_card.dart';
import 'historical_chart_screen.dart';

/// Home / Dashboard de consulta rápida.
class CountryDetailScreen extends ConsumerWidget {
  const CountryDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(selectedCountryProvider);
    final query = ref.watch(countrySearchQueryProvider);
    final results = Countries.search(query);
    final overview = ref.watch(countryOverviewProvider(selected.iso3));

    return Scaffold(
      appBar: AppBar(
        title: const Text('MacroLens'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextField(
              onChanged: (v) =>
                  ref.read(countrySearchQueryProvider.notifier).state = v,
              onSubmitted: (_) {
                if (results.length == 1) {
                  ref.read(selectedCountryProvider.notifier).state = results.first;
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar país ou código ISO (BRA, MOZ, PRT…)',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Nenhum país encontrado.'),
              )
            else
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final c = results[i];
                    return ChoiceChip(
                      label: Text('${c.flag} ${c.iso3}'),
                      selected: c == selected,
                      onSelected: (_) => ref
                          .read(selectedCountryProvider.notifier)
                          .state = c,
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(selected.flag, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(selected.name, style: theme.textTheme.headlineSmall),
                      Text(
                        'ISO ${selected.iso3} · Último valor disponível por indicador',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            overview.when(
              loading: () => const LoadingView(height: 240),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(countryOverviewProvider(selected.iso3)),
              ),
              data: (profile) {
                final snaps = profile.snapshots.values.toList();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    mainAxisExtent: 136,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: snaps.length,
                  itemBuilder: (context, i) => IndicatorMetricCard(
                    snapshot: snaps[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => HistoricalChartScreen(
                          country: selected,
                          initialIndicator: snaps[i].indicator,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Fonte: Banco Mundial (World Bank Open Data). Toque num cartão para ver o histórico.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
