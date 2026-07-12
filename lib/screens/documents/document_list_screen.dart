import 'package:flutter/material.dart';
import '../../core/services/document_service.dart';
import '../../core/services/office_service.dart';
import '../../models/document_model.dart';
import '../../widgets/app_sidebar.dart';
import 'document_detail_screen.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  final DocumentService _documentService = DocumentService();
  final OfficeService _officeService = OfficeService();

  bool _loading = true;
  String? _error;
  List<DocumentModel> _documents = [];

  // Filter data
  List<Map<String, dynamic>> _offices = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _groups = [];

  // Selected filters
  int? _filterOfficeId;
  int? _filterCategoryId;
  int? _filterGroupId;

  @override
  void initState() {
    super.initState();
    _loadOffices();
    _loadDocuments();
  }

  Future<void> _loadOffices() async {
    final data = await _officeService.fetchOffices();
    if (!mounted) return;
    setState(() {
      _offices = data
          .map((e) => {'id': e['id'] as int, 'name': e['name_kh']?.toString() ?? ''})
          .toList();
    });
  }

  Future<void> _onOfficeFilterChanged(int? officeId) async {
    setState(() {
      _filterOfficeId = officeId;
      _filterCategoryId = null;
      _filterGroupId = null;
      _categories = [];
      _groups = [];
    });
    if (officeId != null) {
      final data = await _officeService.fetchCategories(officeId: officeId);
      if (!mounted) return;
      setState(() {
        _categories = data
            .map((e) => {'id': e['id'] as int, 'name': e['name_kh']?.toString() ?? ''})
            .toList();
      });
    }
  }

  Future<void> _onCategoryFilterChanged(int? categoryId) async {
    setState(() {
      _filterCategoryId = categoryId;
      _filterGroupId = null;
      _groups = [];
    });
    if (categoryId != null) {
      final data = await _officeService.fetchGroups(categoryId: categoryId);
      if (!mounted) return;
      setState(() {
        _groups = data
            .map((e) => {'id': e['id'] as int, 'name': e['name_kh']?.toString() ?? ''})
            .toList();
      });
    }
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _documentService.fetchDocuments(
        officeId: _filterOfficeId,
        categoryId: _filterCategoryId,
        groupId: _filterGroupId,
      );
      final documents = data.map(_mapToDocument).toList();

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

  DocumentModel _mapToDocument(dynamic item) {
    return DocumentModel(
      id: item['id'] as int,
      title: item['title']?.toString() ?? '',
      description: item['description']?.toString() ?? '',
      documentNumber: item['document_number']?.toString() ?? '',
      officeName: item['office_name']?.toString() ?? '',
      categoryName: item['category_name']?.toString() ?? '',
      groupName: item['group_name']?.toString() ?? '',
      fileType: item['file_type']?.toString() ?? '',
      fileUrl: item['file_url']?.toString() ?? '',
      uploadedBy: item['uploaded_by']?.toString() ?? '',
      createdAt: item['created_at']?.toString() ?? '',
    );
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
                  // Filter row
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<int>(
                          value: _filterOfficeId,
                          decoration: const InputDecoration(
                            labelText: 'ការិយាល័យ',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            const DropdownMenuItem<int>(value: null, child: Text('ទាំងអស់')),
                            ..._offices.map((o) => DropdownMenuItem<int>(
                                  value: o['id'] as int,
                                  child: Text(o['name'] as String),
                                )),
                          ],
                          onChanged: _onOfficeFilterChanged,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<int>(
                          value: _filterCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'ផ្នែក',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            const DropdownMenuItem<int>(value: null, child: Text('ទាំងអស់')),
                            ..._categories.map((c) => DropdownMenuItem<int>(
                                  value: c['id'] as int,
                                  child: Text(c['name'] as String),
                                )),
                          ],
                          onChanged: _onCategoryFilterChanged,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<int>(
                          value: _filterGroupId,
                          decoration: const InputDecoration(
                            labelText: 'ក្រុម',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            const DropdownMenuItem<int>(value: null, child: Text('ទាំងអស់')),
                            ..._groups.map((g) => DropdownMenuItem<int>(
                                  value: g['id'] as int,
                                  child: Text(g['name'] as String),
                                )),
                          ],
                          onChanged: (v) => setState(() => _filterGroupId = v),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loadDocuments,
                        icon: const Icon(Icons.filter_list),
                        label: const Text('ត្រង'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _filterOfficeId = null;
                            _filterCategoryId = null;
                            _filterGroupId = null;
                            _categories = [];
                            _groups = [];
                          });
                          await _loadDocuments();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('សម្អាត'),
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
            DataColumn(label: Text('ផ្នែក')),
            DataColumn(label: Text('ក្រុម')),
            DataColumn(label: Text('File Type')),
            DataColumn(label: Text('អ្នកបញ្ចូល')),
            DataColumn(label: Text('កាលបរិច្ឆេទ')),
          ],
          rows: _documents
              .map(
                (doc) => DataRow(
                  onSelectChanged: (_) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DocumentDetailScreen(documentId: doc.id),
                      ),
                    );
                  },
                  cells: [
                    DataCell(Text(doc.id.toString())),
                    DataCell(Text(doc.title)),
                    DataCell(Text(doc.documentNumber)),
                    DataCell(Text(doc.officeName)),
                    DataCell(Text(doc.categoryName)),
                    DataCell(Text(doc.groupName)),
                    DataCell(Text(doc.fileType.toUpperCase())),
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
