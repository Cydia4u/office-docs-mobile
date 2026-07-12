import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/services/document_service.dart';
import '../../core/services/office_service.dart';
import '../../widgets/app_sidebar.dart';

/// Supported file-type values sent to the API.
const _kFileTypes = [
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'video',
  'audio',
];

/// File extensions accepted per logical file type.
const _kAllowedExtensions = [
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'mp4',
  'avi',
  'mov',
  'mkv',
  'mp3',
  'wav',
  'aac',
  'm4a',
];

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _documentDateController = TextEditingController();

  final _officeService = OfficeService();
  final _documentService = DocumentService();

  // Dropdown data
  List<Map<String, dynamic>> _offices = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _groups = [];

  // Selected values
  int? _selectedOfficeId;
  int? _selectedCategoryId;
  int? _selectedGroupId;
  String? _selectedFileType;

  // File picker
  String? _pickedFilePath;
  String? _pickedFileName;

  bool _loading = false;
  bool _submitting = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _loadOffices();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _documentNumberController.dispose();
    _documentDateController.dispose();
    super.dispose();
  }

  Future<void> _loadOffices() async {
    setState(() => _loading = true);
    final data = await _officeService.fetchOffices();
    if (!mounted) return;
    setState(() {
      _offices = data
          .map((e) => {'id': e['id'] as int, 'name': e['name_kh']?.toString() ?? ''})
          .toList();
      _loading = false;
    });
  }

  Future<void> _onOfficeChanged(int? officeId) async {
    setState(() {
      _selectedOfficeId = officeId;
      _selectedCategoryId = null;
      _selectedGroupId = null;
      _categories = [];
      _groups = [];
    });
    if (officeId == null) return;
    final data = await _officeService.fetchCategories(officeId: officeId);
    if (!mounted) return;
    setState(() {
      _categories = data
          .map((e) => {'id': e['id'] as int, 'name': e['name_kh']?.toString() ?? ''})
          .toList();
    });
  }

  Future<void> _onCategoryChanged(int? categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _selectedGroupId = null;
      _groups = [];
    });
    if (categoryId == null) return;
    final data = await _officeService.fetchGroups(categoryId: categoryId);
    if (!mounted) return;
    setState(() {
      _groups = data
          .map((e) => {'id': e['id'] as int, 'name': e['name_kh']?.toString() ?? ''})
          .toList();
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _kAllowedExtensions,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFilePath = result.files.first.path;
        _pickedFileName = result.files.first.name;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _documentDateController.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedFilePath == null) {
      setState(() => _error = 'សូមជ្រើសរើសឯកសារ');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
      _success = null;
    });

    try {
      await _documentService.uploadDocument(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        documentNumber: _documentNumberController.text.trim(),
        documentDate: _documentDateController.text.trim(),
        officeId: _selectedOfficeId!,
        categoryId: _selectedCategoryId!,
        groupId: _selectedGroupId!,
        fileType: _selectedFileType!,
        filePath: _pickedFilePath!,
      );

      if (!mounted) return;
      setState(() {
        _submitting = false;
        _success = 'ឯកសារត្រូវបានបញ្ចូលដោយជោគជ័យ!';
      });
      _resetForm();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'បញ្ហាក្នុងការបញ្ចូលឯកសារ: ${e.toString()}';
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _documentNumberController.clear();
    _documentDateController.clear();
    setState(() {
      _selectedOfficeId = null;
      _selectedCategoryId = null;
      _selectedGroupId = null;
      _selectedFileType = null;
      _pickedFilePath = null;
      _pickedFileName = null;
      _categories = [];
      _groups = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('បញ្ចូលឯកសារ')),
      body: Row(
        children: [
          const AppSidebar(selectedIndex: 4),
          const VerticalDivider(width: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ព័ត៌មានឯកសារ',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),

                          // Status messages
                          if (_success != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                color: Colors.green.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(children: [
                                    const Icon(Icons.check_circle, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(_success!, style: const TextStyle(color: Colors.green)),
                                  ]),
                                ),
                              ),
                            ),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                color: Colors.red.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red))),
                                  ]),
                                ),
                              ),
                            ),

                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              // Office
                              SizedBox(
                                width: 320,
                                child: DropdownButtonFormField<int>(
                                  value: _selectedOfficeId,
                                  decoration: const InputDecoration(
                                    labelText: 'ការិយាល័យ *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _offices
                                      .map((o) => DropdownMenuItem<int>(
                                            value: o['id'] as int,
                                            child: Text(o['name'] as String),
                                          ))
                                      .toList(),
                                  onChanged: _onOfficeChanged,
                                  validator: (v) => v == null ? 'សូមជ្រើសរើសការិយាល័យ' : null,
                                ),
                              ),

                              // Section / Category
                              SizedBox(
                                width: 320,
                                child: DropdownButtonFormField<int>(
                                  value: _selectedCategoryId,
                                  decoration: const InputDecoration(
                                    labelText: 'ផ្នែក / ប្រភេទ *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _categories
                                      .map((c) => DropdownMenuItem<int>(
                                            value: c['id'] as int,
                                            child: Text(c['name'] as String),
                                          ))
                                      .toList(),
                                  onChanged: _onCategoryChanged,
                                  validator: (v) => v == null ? 'សូមជ្រើសរើសផ្នែក' : null,
                                ),
                              ),

                              // Group
                              SizedBox(
                                width: 320,
                                child: DropdownButtonFormField<int>(
                                  value: _selectedGroupId,
                                  decoration: const InputDecoration(
                                    labelText: 'ក្រុម *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _groups
                                      .map((g) => DropdownMenuItem<int>(
                                            value: g['id'] as int,
                                            child: Text(g['name'] as String),
                                          ))
                                      .toList(),
                                  onChanged: (v) => setState(() => _selectedGroupId = v),
                                  validator: (v) => v == null ? 'សូមជ្រើសរើសក្រុម' : null,
                                ),
                              ),

                              // File type
                              SizedBox(
                                width: 320,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedFileType,
                                  decoration: const InputDecoration(
                                    labelText: 'ប្រភេទ File *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _kFileTypes
                                      .map((t) => DropdownMenuItem<String>(
                                            value: t,
                                            child: Text(t.toUpperCase()),
                                          ))
                                      .toList(),
                                  onChanged: (v) => setState(() => _selectedFileType = v),
                                  validator: (v) => v == null ? 'សូមជ្រើសរើសប្រភេទ File' : null,
                                ),
                              ),

                              // Title
                              SizedBox(
                                width: 320,
                                child: TextFormField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'ចំណងជើងឯកសារ *',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty) ? 'សូមបញ្ចូលចំណងជើង' : null,
                                ),
                              ),

                              // Document number
                              SizedBox(
                                width: 320,
                                child: TextFormField(
                                  controller: _documentNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'លេខឯកសារ',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              // Document date
                              SizedBox(
                                width: 320,
                                child: TextFormField(
                                  controller: _documentDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'កាលបរិច្ឆេទឯកសារ',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      onPressed: _pickDate,
                                      icon: const Icon(Icons.calendar_today),
                                    ),
                                  ),
                                  onTap: _pickDate,
                                ),
                              ),

                              // Description
                              SizedBox(
                                width: 656,
                                child: TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    labelText: 'សេចក្ដីពិពណ៌នា',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // File picker
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.attach_file),
                                label: const Text('ជ្រើសរើសឯកសារ'),
                              ),
                              if (_pickedFileName != null) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.insert_drive_file, size: 20),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _pickedFileName!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ប្រភេទឯកសារដែលអនុញ្ញាត: PDF, DOC, DOCX, XLS, XLSX, MP4, AVI, MOV, MKV, MP3, WAV, AAC, M4A',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          const SizedBox(height: 24),

                          Row(
                            children: [
                              FilledButton(
                                onPressed: _submitting ? null : _submit,
                                child: _submitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Text('រក្សាទុក'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: _submitting ? null : _resetForm,
                                child: const Text('សម្អាត'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
