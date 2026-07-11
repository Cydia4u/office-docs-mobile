import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import '../constants/api_constants.dart';

class ApiClient {
  Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (withAuth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  Future<http.Response> get(String path, {bool withAuth = false}) async {
    return http.get(_uri(path), headers: await _headers(withAuth: withAuth));
  }

  Future<http.Response> post(String path, Map<String, dynamic> body, {bool withAuth = false}) async {
    return http.post(
      _uri(path),
      headers: await _headers(withAuth: withAuth),
      body: jsonEncode(body),
    );
  }
}
