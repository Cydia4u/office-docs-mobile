import 'dart:convert';
import '../constants/api_constants.dart';
import 'api_client.dart';

class DocumentService {
  final ApiClient _client = ApiClient();

  Future<List<dynamic>> fetchDocuments() async {
    final response = await _client.get(ApiConstants.documents, withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to load documents');
  }

  Future<List<dynamic>> searchDocuments({String? query}) async {
    final path = query != null && query.trim().isNotEmpty
        ? '${ApiConstants.documents}?search=${Uri.encodeComponent(query.trim())}'
        : ApiConstants.documents;
    final response = await _client.get(path, withAuth: true);
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
}
