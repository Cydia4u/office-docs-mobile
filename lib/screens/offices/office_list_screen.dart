import 'package:flutter/material.dart';
import '../../core/services/office_service.dart';
import '../../models/office_model.dart';
import '../../widgets/app_sidebar.dart';

class OfficeListScreen extends StatefulWidget {
  const OfficeListScreen({super.key});

  @override
  State<OfficeListScreen> createState() => _OfficeListScreenState();
}

class _OfficeListScreenState extends State<OfficeListScreen> {
  final OfficeService _officeService = OfficeService();
  bool _loading = true;
  String? _error;
  List<OfficeModel> _offices = [];

  @override
  void initState() {
    super.initState();
    _loadOffices();
  }

  Future<void> _loadOffices() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _officeService.fetchOffices();
      final offices = data.map((item) {
        return OfficeModel(
          id: item['id'] as int,
          nameKh: item['name_kh']?.toString() ?? '',
          code: item['code']?.toString() ?? '',
          departmentName: item['department_name']?.toString() ?? '',
          status: item['status'] == true,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _offices = offices;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'មិនអាចទាញយកទិន្នន័យការិយាល័យបានទេ។';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: _loadOffices,
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

    if (_offices.isEmpty) {
      return const Center(child: Text('មិនមានទិន្នន័យការិយាល័យទេ')); 
    }

    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ល.រ')),
            DataColumn(label: Text('ឈ្មោះការិយាល័យ')),
            DataColumn(label: Text('កូដ')),
            DataColumn(label: Text('អង្គភាព')),
            DataColumn(label: Text('ស្ថានភាព')),
          ],
          rows: _offices
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
    );
  }
}
