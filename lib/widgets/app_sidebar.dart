import 'package:flutter/material.dart';
import '../models/dashboard_stat.dart';
import '../screens/categories/category_list_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/documents/document_list_screen.dart';
import '../screens/documents/upload_document_screen.dart';
import '../screens/offices/office_list_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;

  const AppSidebar({super.key, required this.selectedIndex});

  void _go(BuildContext context, int index) {
    final screens = [
      const DashboardScreen(),
      const OfficeListScreen(),
      const CategoryListScreen(),
      const DocumentListScreen(),
      const UploadDocumentScreen(),
      const SearchScreen(),
      const SettingsScreen(),
    ];

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screens[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (index) => _go(context, index),
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
          icon: Icon(Icons.upload_file_outlined),
          selectedIcon: Icon(Icons.upload_file),
          label: Text('បញ្ចូលឯកសារ'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: Text('ស្វែងរក'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('ការកំណត់'),
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
