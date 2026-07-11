import 'package:flutter/material.dart';
import '../../models/dashboard_stat.dart';
import '../../widgets/app_sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      DashboardStat(title: 'ចំនួនការិយាល័យ', value: '12'),
      DashboardStat(title: 'ប្រភេទឯកសារ', value: '36'),
      DashboardStat(title: 'ឯកសារសរុប', value: '1,280'),
      DashboardStat(title: 'ឯកសារថ្មីថ្ងៃនេះ', value: '14'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ផ្ទាំងគ្រប់គ្រង'),
      ),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 0),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'សូមស្វាគមន៍',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.4,
                      children: stats
                          .map((stat) => StatCard(stat: stat))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
