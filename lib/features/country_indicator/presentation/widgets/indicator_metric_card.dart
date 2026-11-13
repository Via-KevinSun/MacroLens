import 'package:flutter/material.dart';

import '../../../../core/constants/indicators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/country_profile.dart';

class IndicatorMetricCard extends StatelessWidget {
  const IndicatorMetricCard({super.key, required this.snapshot, this.onTap});

  final IndicatorSnapshot snapshot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final indicator = snapshot.indicator;

    return SurfaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            indicator.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(color: muted),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              NumberFormatter.byUnit(indicator.unit, snapshot.value),
              style: theme.textTheme.headlineSmall,
            ),
          ),
          Row(
            children: [
              _ChangeBadge(snapshot: snapshot),
              const Spacer(),
              Text(
                snapshot.year?.toString() ?? 'Sem dados',
                style: theme.textTheme.labelSmall?.copyWith(color: muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.snapshot});
  final IndicatorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final change = snapshot.changePercent;
    if (change == null) return const SizedBox.shrink();

    final positive = change >= 0;
    final color = positive ? AppColors.emerald : AppColors.coral;
    final sign = positive ? '+' : '';
    final text = snapshot.indicator.unit == IndicatorUnit.percent
        ? '$sign${change.toStringAsFixed(2)} p.p.'
        : NumberFormatter.signedPercent(change);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
