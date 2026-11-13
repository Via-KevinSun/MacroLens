import 'package:flutter/material.dart';

import '../../../../core/constants/countries.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final CountryOption value;
  final ValueChanged<CountryOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.iso3,
          isExpanded: true,
          items: [
            for (final c in Countries.all)
              DropdownMenuItem(
                value: c.iso3,
                child: Text('${c.flag} ${c.name}', overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (iso3) {
            final country = iso3 == null ? null : Countries.byCode(iso3);
            if (country != null) onChanged(country);
          },
        ),
      ),
    );
  }
}
