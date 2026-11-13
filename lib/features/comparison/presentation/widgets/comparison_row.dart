import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';

class ComparisonHeader extends StatelessWidget {
  const ComparisonHeader({
    super.key,
    required this.labelA,
    required this.labelB,
    required this.colorA,
    required this.colorB,
  });

  final String labelA;
  final String labelB;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return Row(
      children: [
        const Expanded(flex: 3, child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: Text(labelA,
              textAlign: TextAlign.right,
              style: style?.copyWith(color: colorA)),
        ),
        Expanded(
          flex: 2,
          child: Text(labelB,
              textAlign: TextAlign.right,
              style: style?.copyWith(color: colorB)),
        ),
      ],
    );
  }
}

class ComparisonRow extends StatelessWidget {
  const ComparisonRow({
    super.key,
    required this.label,
    required this.valueA,
    required this.valueB,
  });

  final String label;
  final String valueA;
  final String valueB;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(valueA, textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text(valueB, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class ComparisonDiffRow extends StatelessWidget {
  const ComparisonDiffRow({super.key, required this.label, required this.percent});

  final String label;
  final double? percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = percent == null
        ? theme.colorScheme.onSurface
        : (percent! >= 0 ? AppColors.emerald : AppColors.coral);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Text(
            NumberFormatter.signedPercent(percent),
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
