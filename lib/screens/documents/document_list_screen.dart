import 'package:flutter/material.dart';
import '../../core/services/document_service.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  final DocumentService _documentService = DocumentService();
  bool _loading = true;
  String? _error;
  List<DocumentModel> _documents = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _documentService.fetchDocuments();
      final documents = data.map((item) {
        return DocumentModel(
          id: item['id'] as int,
          title: item['title']?.toString() ?? '',
          documentNumber: item['document_number']?.toString() ?? '',
          officeName: item['office_name']?.toString() ?? '',
          categoryName: item['category_name']?.toString() ?? '',
          fileType: item['file_type']?.toString() ?? '',
          uploadedBy: item['uploaded_by']?.toString() ?? '',
          createdAt: item['created_at']?.toString() ?? '',
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _documents = documents;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'មិនអាចទាញយកឯកសារបានទេ។';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      FilledButton.icon(
                        onPressed: _loadDocuments,
                        icon: const Icon(Icons.refresh),
                        label: const Text('ផ្ទុកឡើងវិញ'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_documents.isEmpty) {
      return const Center(child: Text('មិនមានទិន្នន័យឯកសារទេ'));
    }

    return Card(
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
          rows: _documents
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
    );
  }
}
