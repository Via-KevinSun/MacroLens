import 'package:flutter/material.dart';

import 'features/comparison/presentation/screens/country_comparison_screen.dart';
import 'features/country_indicator/presentation/screens/country_detail_screen.dart';

/// Navegação principal: bottom bar em ecrãs estreitos, rail lateral em largos.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = <Widget>[
    CountryDetailScreen(),
    CountryComparisonScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(index: _index, children: _pages);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Painel'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.compare_arrows),
                      selectedIcon: Icon(Icons.compare_arrows),
                      label: Text('Comparar'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }
        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Painel',
              ),
              NavigationDestination(
                icon: Icon(Icons.compare_arrows),
                label: 'Comparar',
              ),
            ],
          ),
        );
      },
    );
  }
}
