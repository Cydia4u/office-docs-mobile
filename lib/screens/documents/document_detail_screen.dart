import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';

class DocumentDetailScreen extends StatelessWidget {
  final DocumentModel document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ព័ត៌មានឯកសារ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 3),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      _infoRow('លេខឯកសារ', document.documentNumber),
                      _infoRow('ការិយាល័យ', document.officeName),
                      _infoRow('ប្រភេទឯកសារ', document.categoryName),
                      _infoRow('ប្រភេទ File', document.fileType),
                      _infoRow('អ្នកបញ្ចូល', document.uploadedBy),
                      _infoRow('កាលបរិច្ឆេទ', document.createdAt),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('ទាញយក'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: const Text('កែប្រែ'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.delete),
                            label: const Text('លុប'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
