import 'package:flutter/material.dart';
import '../../core/services/office_service.dart';
import '../../models/category_model.dart';
import '../../widgets/app_sidebar.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final OfficeService _officeService = OfficeService();
  bool _loading = true;
  String? _error;
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _officeService.fetchCategories();
      final categories = data.map((item) {
        return CategoryModel(
          id: item['id'] as int,
          officeName: item['office_name']?.toString() ?? '',
          nameKh: item['name_kh']?.toString() ?? '',
          code: item['code']?.toString() ?? '',
          status: item['status'] == true,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'មិនអាចទាញយកប្រភេទឯកសារបានទេ។';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ប្រភេទឯកសារ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 2),
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
                          decoration: const InputDecoration(
                            labelText: 'ស្វែងរកប្រភេទឯកសារ',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _loadCategories,
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

    if (_categories.isEmpty) {
      return const Center(child: Text('មិនមានទិន្នន័យប្រភេទឯកសារទេ'));
    }

    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ល.រ')),
            DataColumn(label: Text('ការិយាល័យ')),
            DataColumn(label: Text('ប្រភេទឯកសារ')),
            DataColumn(label: Text('កូដ')),
            DataColumn(label: Text('ស្ថានភាព')),
          ],
          rows: _categories
              .map(
                (category) => DataRow(
                  cells: [
                    DataCell(Text(category.id.toString())),
                    DataCell(Text(category.officeName)),
                    DataCell(Text(category.nameKh)),
                    DataCell(Text(category.code)),
                    DataCell(Text(category.status ? 'ដំណើរការ' : 'បិទ')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
