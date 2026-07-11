import 'package:flutter/material.dart';
import '../../core/services/document_service.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';
import '../documents/document_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DocumentService _documentService = DocumentService();
  final TextEditingController _searchController = TextEditingController();

  bool _loading = false;
  String? _error;
  List<DocumentModel> _results = [];

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _documentService.searchDocuments(query: _searchController.text);
      final results = data.map((item) {
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
        _results = results;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'មិនអាចស្វែងរកឯកសារបានទេ។';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'ចំណងជើង / លេខឯកសារ',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search),
                        label: const Text('ស្វែងរក'),
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

    if (_results.isEmpty) {
      return const Center(child: Text('មិនមានលទ្ធផលទេ'));
    }

    return Card(
      child: ListView.separated(
        itemCount: _results.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final doc = _results[index];
          return ListTile(
            title: Text(doc.title),
            subtitle: Text('${doc.documentNumber} • ${doc.officeName} • ${doc.fileType}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DocumentDetailScreen(documentId: doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
