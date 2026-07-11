import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';

class DocumentListScreen extends StatelessWidget {
  const DocumentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const documents = [
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
      appBar: AppBar(title: const Text('បញ្ជីឯកសារ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 3),
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
                      SizedBox(
                        width: 260,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'ស្វែងរកឯកសារ',
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
                            labelText: 'ប្រភេទ file',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('ទាំងអស់')),
                            DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                            DropdownMenuItem(value: 'xlsx', child: Text('XLSX')),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ល.រ')),
                            DataColumn(label: Text('ចំណងជើង')),
                            DataColumn(label: Text('លេខឯកសារ')),
                            DataColumn(label: Text('ការិយាល័យ')),
                            DataColumn(label: Text('ប្រភេទ')),
                            DataColumn(label: Text('File Type')),
                            DataColumn(label: Text('អ្នកបញ្ចូល')),
                            DataColumn(label: Text('កាលបរិច្ឆេទ')),
                          ],
                          rows: documents
                              .map(
                                (doc) => DataRow(
                                  cells: [
                                    DataCell(Text(doc.id.toString())),
                                    DataCell(Text(doc.title)),
                                    DataCell(Text(doc.documentNumber)),
                                    DataCell(Text(doc.officeName)),
                                    DataCell(Text(doc.categoryName)),
                                    DataCell(Text(doc.fileType)),
                                    DataCell(Text(doc.uploadedBy)),
                                    DataCell(Text(doc.createdAt)),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
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
