import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ការកំណត់')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 6),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: const [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.business),
                      title: Text('ព័ត៌មានអង្គភាព'),
                      subtitle: Text('កំណត់ឈ្មោះ និងព័ត៌មានសង្ខេបរបស់អង្គភាព'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('ប្តូរពាក្យសម្ងាត់'),
                      subtitle: Text('កែប្រែពាក្យសម្ងាត់សម្រាប់គណនីបច្ចុប្បន្ន'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.language),
                      title: Text('ភាសា'),
                      subtitle: Text('ភាសាខ្មែរ'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.backup),
                      title: Text('បម្រុងទុកទិន្នន័យ'),
                      subtitle: Text('Backup និង Restore ទិន្នន័យ'),
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
