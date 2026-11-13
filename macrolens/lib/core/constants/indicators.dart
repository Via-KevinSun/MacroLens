enum IndicatorUnit { currency, percent, count, years }

enum IndicatorType {
  gdp('NY.GDP.MKTP.CD', 'PIB Total', IndicatorUnit.currency),
  gdpGrowth('NY.GDP.MKTP.KD.ZG', 'Crescimento do PIB', IndicatorUnit.percent),
  inflation('FP.CPI.TOTL.ZG', 'Inflação', IndicatorUnit.percent),
  population('SP.POP.TOTL', 'População', IndicatorUnit.count),
  lifeExpectancy('SP.DYN.LE00.IN', 'Expectativa de Vida', IndicatorUnit.years);

  const IndicatorType(this.id, this.label, this.unit);
  final String id;
  final String label;
  final IndicatorUnit unit;
}
