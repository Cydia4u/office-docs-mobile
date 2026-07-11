import 'dart:convert';
import '../constants/api_constants.dart';
import '../utils/token_storage.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<bool> login({required String username, required String password}) async {
    final response = await _client.post(ApiConstants.login, {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      if (token != null) {
        await TokenStorage.saveToken(token);
        return true;
      }
    }

    return false;
  }

  Future<void> logout() async {
    await _client.post(ApiConstants.logout, {}, withAuth: true);
    await TokenStorage.clearToken();
  }
}
