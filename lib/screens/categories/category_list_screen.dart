import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../widgets/app_sidebar.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = [
      CategoryModel(id: 1, officeName: 'ការិយាល័យបុគ្គលិក', nameKh: 'បញ្ជីរាយនាម', code: 'CAT-001', status: true),
      CategoryModel(id: 2, officeName: 'ការិយាល័យបុគ្គលិក', nameKh: 'របាយការណ៍ចំនួនទ័ព', code: 'CAT-002', status: true),
      CategoryModel(id: 3, officeName: 'ការិយាល័យហិរញ្ញវត្ថុ', nameKh: 'បញ្ជីចំណាយ', code: 'CAT-003', status: false),
    ];

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
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('បន្ថែម'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ល.រ')),
                            DataColumn(label: Text('ការិយាល័យ')),
                            DataColumn(label: Text('ប្រភេទឯកសារ')),
                            DataColumn(label: Text('កូដ')),
                            DataColumn(label: Text('ស្ថានភាព')),
                          ],
                          rows: categories
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
