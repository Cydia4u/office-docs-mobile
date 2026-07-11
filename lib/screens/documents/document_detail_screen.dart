import 'package:flutter/material.dart';
import '../../core/services/document_service.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';

class DocumentDetailScreen extends StatefulWidget {
  final int documentId;

  const DocumentDetailScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  final DocumentService _documentService = DocumentService();
  bool _loading = true;
  String? _error;
  DocumentModel? _document;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final item = await _documentService.fetchDocumentById(widget.documentId);
      final document = DocumentModel(
        id: item['id'] as int,
        title: item['title']?.toString() ?? '',
        documentNumber: item['document_number']?.toString() ?? '',
        officeName: item['office_name']?.toString() ?? '',
        categoryName: item['category_name']?.toString() ?? '',
        fileType: item['file_type']?.toString() ?? '',
        uploadedBy: item['uploaded_by']?.toString() ?? '',
        createdAt: item['created_at']?.toString() ?? '',
      );

      if (!mounted) return;
      setState(() {
        _document = document;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'មិនអាចទាញយកព័ត៌មានឯកសារបានទេ។';
        _loading = false;
      });
    }
  }

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
              child: _buildBody(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_document == null) {
      return const Center(child: Text('មិនមានព័ត៌មានឯកសារ'));
    }

    final document = _document!;
    return Card(
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
