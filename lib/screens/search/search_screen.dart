import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';
import '../documents/document_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const results = [
      DocumentModel(
        id: 1,
        title: 'បញ្ជីរាយនាមប្រចាំខែ',
        documentNumber: 'DOC-001',
        officeName: 'ការិយាល័យបុគ្គលិក',
        categoryName: 'បញ្ជីរាយនាម',
        fileType: 'PDF',
        uploadedBy: 'Admin',
        createdAt: '2026-07-11',
      ),
      DocumentModel(
        id: 2,
        title: 'របាយការណ៍ចំណាយ',
        documentNumber: 'DOC-002',
        officeName: 'ការិយាល័យហិរញ្ញវត្ថុ',
        categoryName: 'បញ្ជីចំណាយ',
        fileType: 'XLSX',
        uploadedBy: 'Manager',
        createdAt: '2026-07-10',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ស្វែងរកឯកសារ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 5),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      const SizedBox(
                        width: 240,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'ចំណងជើង / លេខឯកសារ',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'ការិយាល័យ',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('ទាំងអស់')),
                            DropdownMenuItem(value: 'staff', child: Text('ការិយាល័យបុគ្គលិក')),
                            DropdownMenuItem(value: 'finance', child: Text('ការិយាល័យហិរញ្ញវត្ថុ')),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'ប្រភេទឯកសារ',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('ទាំងអស់')),
                            DropdownMenuItem(value: 'list', child: Text('បញ្ជីរាយនាម')),
                            DropdownMenuItem(value: 'report', child: Text('របាយការណ៍')),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                        label: const Text('ស្វែងរក'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      child: ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final doc = results[index];
                          return ListTile(
                            title: Text(doc.title),
                            subtitle: Text('${doc.documentNumber} • ${doc.officeName} • ${doc.fileType}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DocumentDetailScreen(document: doc),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
