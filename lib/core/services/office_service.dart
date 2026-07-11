import 'dart:convert';
import '../constants/api_constants.dart';
import 'api_client.dart';

class OfficeService {
  final ApiClient _client = ApiClient();

  Future<List<dynamic>> fetchOffices() async {
    final response = await _client.get(ApiConstants.offices, withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    return [];
  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await _client.get(ApiConstants.categories, withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    return [];
  }
}
