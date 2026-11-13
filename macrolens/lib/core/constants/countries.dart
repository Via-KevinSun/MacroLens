import 'package:equatable/equatable.dart';

class CountryOption extends Equatable {
  const CountryOption(this.iso3, this.name, this.flag);
  final String iso3;
  final String name;
  final String flag;

  @override
  List<Object?> get props => [iso3];
}

class Countries {
  Countries._();

  static const List<CountryOption> all = [
    CountryOption('MOZ', 'Moçambique', '🇲🇿'),
    CountryOption('BRA', 'Brasil', '🇧🇷'),
    CountryOption('PRT', 'Portugal', '🇵🇹'),
    CountryOption('USA', 'Estados Unidos', '🇺🇸'),
    CountryOption('DEU', 'Alemanha', '🇩🇪'),
    CountryOption('ZAF', 'África do Sul', '🇿🇦'),
    CountryOption('AGO', 'Angola', '🇦🇴'),
    CountryOption('CHN', 'China', '🇨🇳'),
    CountryOption('IND', 'Índia', '🇮🇳'),
    CountryOption('GBR', 'Reino Unido', '🇬🇧'),
    CountryOption('FRA', 'França', '🇫🇷'),
    CountryOption('JPN', 'Japão', '🇯🇵'),
  ];

  static List<CountryOption> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where((c) =>
            c.name.toLowerCase().contains(q) || c.iso3.toLowerCase().contains(q))
        .toList();
  }

  static CountryOption? byCode(String iso3) {
    for (final c in all) {
      if (c.iso3 == iso3) return c;
    }
    return null;
  }
}
