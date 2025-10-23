import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
    return {'Content-Type': 'application/json'};
  }

  Future<http.Response> get(String path) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl$path');
    return http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl$path');
    return http
        .post(uri, headers: headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 10));
  }

  Future<http.Response> put(String path, {Map<String, dynamic>? body}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl$path');
    final encoded = body != null ? jsonEncode(body) : null;
    return http
        .put(uri, headers: headers, body: encoded)
        .timeout(const Duration(seconds: 10));
  }

  // Exemplo: login que salva token
  Future<bool> login(String email, String password) async {
    // Ajuste: rota e campos conforme schemas do servidor
    final resp = await post('/usuarioLogin', {
      'user_email': email,
      'user_password': password,
    });
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
