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

  Future<Map<String, String>> _authHeaders() async {
    final headers = <String, String>{'Accept': 'application/json'};
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
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

  /// Uploads a document using multipart/form-data. [fields] are the text
  /// metadata fields. When [filePath] and [fileField] are supplied the file
  /// at [filePath] is attached under the given [fileField] name.
  Future<http.Response> postMultipart(
    String path,
    Map<String, String> fields, {
    String? filePath,
    String? fileField,
  }) async {
    final uri = _uri(path);
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _authHeaders());
    request.fields.addAll(fields);

    if (filePath != null && fileField != null) {
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    }

    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }
}
