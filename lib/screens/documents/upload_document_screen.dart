import 'package:flutter/material.dart';
import '../../widgets/app_sidebar.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('បញ្ចូលឯកសារ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 4),
          const VerticalDivider(width: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ព័ត៌មានឯកសារ',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: 320,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'ការិយាល័យ',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'staff', child: Text('ការិយាល័យបុគ្គលិក')),
                            DropdownMenuItem(value: 'finance', child: Text('ការិយាល័យហិរញ្ញវត្ថុ')),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'ប្រភេទឯកសារ',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'list', child: Text('បញ្ជីរាយនាម')),
                            DropdownMenuItem(value: 'report', child: Text('របាយការណ៍')),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                      const SizedBox(
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'ចំណងជើងឯកសារ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'លេខឯកសារ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 320,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'កាលបរិច្ឆេទឯកសារ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 656,
                        child: TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'សេចក្ដីពិពណ៌នា',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file),
                    label: const Text('ជ្រើសរើសឯកសារ'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: const Text('រក្សាទុក'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('សម្អាត'),
                      ),
                    ],
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
