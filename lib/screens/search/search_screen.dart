import 'package:flutter/material.dart';
import '../../core/services/document_service.dart';
import '../../core/services/office_service.dart';
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
  final OfficeService _officeService = OfficeService();
  final TextEditingController _searchController = TextEditingController();

  bool _loading = false;
  String? _error;
  List<DocumentModel> _results = [];

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
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _documentService.searchDocuments(
        query: _searchController.text,
        officeId: _filterOfficeId,
        categoryId: _filterCategoryId,
        groupId: _filterGroupId,
      );
      final results = data.map(_mapToDocument).toList();

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
                  // Search bar
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
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search),
                        label: const Text('ស្វែងរក'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Filter dropdowns
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 190,
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
                        width: 190,
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
                        width: 190,
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
            leading: _fileTypeIcon(doc.fileType),
            title: Text(doc.title),
            subtitle: Text(
              '${doc.documentNumber.isNotEmpty ? '${doc.documentNumber} • ' : ''}'
              '${doc.officeName} • ${doc.categoryName}'
              '${doc.groupName.isNotEmpty ? ' • ${doc.groupName}' : ''}'
              ' • ${doc.fileType.toUpperCase()}',
            ),
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

  Widget _fileTypeIcon(String fileType) {
    IconData icon;
    Color color;
    switch (fileType.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'video':
        icon = Icons.videocam;
        color = Colors.purple;
        break;
      case 'audio':
        icon = Icons.audiotrack;
        color = Colors.orange;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }
    return Icon(icon, color: color, size: 32);
  }
}
