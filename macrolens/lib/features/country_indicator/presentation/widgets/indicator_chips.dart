import 'package:flutter/material.dart';

import '../../../../core/constants/indicators.dart';

class IndicatorChips extends StatelessWidget {
  const IndicatorChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final IndicatorType selected;
  final ValueChanged<IndicatorType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final indicator in IndicatorType.values)
          ChoiceChip(
            label: Text(indicator.label),
            selected: indicator == selected,
            onSelected: (_) => onSelected(indicator),
          ),
      ],
    );
  }
}
