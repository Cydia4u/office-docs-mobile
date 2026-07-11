import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../auth/login_screen.dart';
import '../../widgets/app_sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ផ្ទាំងគ្រប់គ្រង'),
        actions: [
          IconButton(
            tooltip: 'ចាកចេញ',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 0),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  Card(child: Center(child: Text('ការិយាល័យ'))),
                  Card(child: Center(child: Text('ប្រភេទឯកសារ'))),
                  Card(child: Center(child: Text('ឯកសារ'))),
                  Card(child: Center(child: Text('អ្នកប្រើប្រាស់'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
