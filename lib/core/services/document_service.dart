import 'dart:convert';
import '../constants/api_constants.dart';
import 'api_client.dart';

class DocumentService {
  final ApiClient _client = ApiClient();

  Future<List<dynamic>> fetchDocuments({
    int? officeId,
    int? categoryId,
    int? groupId,
  }) async {
    final params = <String, String>{};
    if (officeId != null) params['office_id'] = officeId.toString();
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (groupId != null) params['group_id'] = groupId.toString();

    final query = params.isNotEmpty
        ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';
    final response = await _client.get('${ApiConstants.documents}$query', withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to load documents');
  }

  Future<List<dynamic>> searchDocuments({
    String? query,
    int? officeId,
    int? categoryId,
    int? groupId,
  }) async {
    final params = <String, String>{};
    if (query != null && query.trim().isNotEmpty) {
      params['search'] = Uri.encodeComponent(query.trim());
    }
    if (officeId != null) params['office_id'] = officeId.toString();
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (groupId != null) params['group_id'] = groupId.toString();

    final queryString = params.isNotEmpty
        ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';
    final response =
        await _client.get('${ApiConstants.documents}$queryString', withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to search documents');
  }

  Future<Map<String, dynamic>> fetchDocumentById(int id) async {
    final response = await _client.get('${ApiConstants.documents}/$id', withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load document detail');
  }

  /// Uploads a new document. [filePath] is the local path to the selected
  /// file. Returns the created document map on success or throws on failure.
  Future<Map<String, dynamic>> uploadDocument({
    required String title,
    required String description,
    required String documentNumber,
    required String documentDate,
    required int officeId,
    required int categoryId,
    required int groupId,
    required String fileType,
    required String filePath,
  }) async {
    final fields = <String, String>{
      'title': title,
      'description': description,
      'document_number': documentNumber,
      'document_date': documentDate,
      'office_id': officeId.toString(),
      'category_id': categoryId.toString(),
      'group_id': groupId.toString(),
      'file_type': fileType,
    };

    final response = await _client.postMultipart(
      ApiConstants.documents,
      fields,
      filePath: filePath,
      fileField: 'file',
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to upload document (${response.statusCode})');
  }
}
