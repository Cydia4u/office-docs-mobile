import 'package:flutter/material.dart';
import '../models/dashboard_stat.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('ទំព័រដើម'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.apartment_outlined),
          selectedIcon: Icon(Icons.apartment),
          label: Text('ការិយាល័យ'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: Text('ប្រភេទឯកសារ'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.folder_open_outlined),
          selectedIcon: Icon(Icons.folder_open),
          label: Text('ឯកសារ'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: Text('ស្វែងរក'),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final DashboardStat stat;

  const StatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stat.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              stat.value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
