import 'package:intl/intl.dart';

import '../constants/indicators.dart';

class NumberFormatter {
  NumberFormatter._();

  static const String placeholder = '—';

  /// 1234 -> 1.23K | 2.08e12 -> 2.08T (sufixos K, M, B, T)
  static String compact(double? value, {int decimals = 2}) {
    if (value == null) return placeholder;
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    const units = [
      (1e12, 'T'),
      (1e9, 'B'),
      (1e6, 'M'),
      (1e3, 'K'),
    ];
    for (final (limit, suffix) in units) {
      if (abs >= limit) {
        return '$sign${(abs / limit).toStringAsFixed(decimals)}$suffix';
      }
    }
    return '$sign${abs.toStringAsFixed(decimals)}';
  }

  /// $ 2.08 Trilhões (formato longo para tooltips)
  static String currencyLong(double? value) {
    if (value == null) return placeholder;
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1e12) return '$sign\$ ${(abs / 1e12).toStringAsFixed(2)} Trilhões';
    if (abs >= 1e9) return '$sign\$ ${(abs / 1e9).toStringAsFixed(2)} Biliões';
    if (abs >= 1e6) return '$sign\$ ${(abs / 1e6).toStringAsFixed(2)} Milhões';
    return '$sign\$ ${NumberFormat('#,##0.00').format(abs)}';
  }

  static String currency(double? value) =>
      value == null ? placeholder : '\$ ${compact(value)}';

  static String percent(double? value, {int decimals = 2}) =>
      value == null ? placeholder : '${value.toStringAsFixed(decimals)}%';

  static String population(double? value) => compact(value);

  static String years(double? value) =>
      value == null ? placeholder : '${value.toStringAsFixed(1)} anos';

  /// Variação com sinal: +3.45% / -1.20%
  static String signedPercent(double? value) {
    if (value == null) return placeholder;
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  /// Valor abreviado, conforme a unidade do indicador.
  static String byUnit(IndicatorUnit unit, double? value) => switch (unit) {
        IndicatorUnit.currency => currency(value),
        IndicatorUnit.percent => percent(value),
        IndicatorUnit.count => population(value),
        IndicatorUnit.years => years(value),
      };

  /// Valor completo para tooltips.
  static String tooltip(IndicatorUnit unit, double? value) => switch (unit) {
        IndicatorUnit.currency => currencyLong(value),
        IndicatorUnit.percent => percent(value),
        IndicatorUnit.count => compact(value),
        IndicatorUnit.years => years(value),
      };
}
