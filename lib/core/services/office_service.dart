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

  Future<List<dynamic>> fetchCategories({int? officeId}) async {
    final path = officeId != null
        ? '${ApiConstants.categories}?office_id=$officeId'
        : ApiConstants.categories;
    final response = await _client.get(path, withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    return [];
  }

  Future<List<dynamic>> fetchGroups({int? categoryId}) async {
    final path = categoryId != null
        ? '${ApiConstants.groups}?category_id=$categoryId'
        : ApiConstants.groups;
    final response = await _client.get(path, withAuth: true);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    return [];
  }
}
