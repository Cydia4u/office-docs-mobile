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
    return [];
  }
}
