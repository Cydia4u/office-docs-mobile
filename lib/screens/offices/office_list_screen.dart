import 'package:flutter/material.dart';
import '../../models/office_model.dart';
import '../../widgets/app_sidebar.dart';

class OfficeListScreen extends StatelessWidget {
  const OfficeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const offices = [
      OfficeModel(id: 1, nameKh: 'ការិយាល័យបុគ្គលិក', code: 'OFF-001', departmentName: 'អង្គភាព A', status: true),
      OfficeModel(id: 2, nameKh: 'ការិយាល័យហិរញ្ញវត្ថុ', code: 'OFF-002', departmentName: 'អង្គភាព A', status: true),
      OfficeModel(id: 3, nameKh: 'ការិយាល័យរដ្ឋបាល', code: 'OFF-003', departmentName: 'អង្គភាព B', status: false),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('បញ្ជីការិយាល័យ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 1),
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
                            labelText: 'ស្វែងរកការិយាល័យ',
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
                            DataColumn(label: Text('ឈ្មោះការិយាល័យ')),
                            DataColumn(label: Text('កូដ')),
                            DataColumn(label: Text('អង្គភាព')),
                            DataColumn(label: Text('ស្ថានភាព')),
                          ],
                          rows: offices
                              .map(
                                (office) => DataRow(
                                  cells: [
                                    DataCell(Text(office.id.toString())),
                                    DataCell(Text(office.nameKh)),
                                    DataCell(Text(office.code)),
                                    DataCell(Text(office.departmentName)),
                                    DataCell(Text(office.status ? 'ដំណើរការ' : 'បិទ')),
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
