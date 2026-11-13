import 'package:flutter/material.dart';

import '../../domain/usecases/get_historical_indicator_usecase.dart';

class YearFilterChips extends StatelessWidget {
  const YearFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final HistoryPeriod selected;
  final ValueChanged<HistoryPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final period in HistoryPeriod.values)
          ChoiceChip(
            label: Text(period.label),
            selected: period == selected,
            onSelected: (_) => onSelected(period),
          ),
      ],
    );
  }
}
