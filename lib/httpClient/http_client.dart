import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://api.royaldusk.com'; 
  final http.Client _client = http.Client();

  Future<http.Response> post(String path, Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<http.Response> get(String path) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/$path'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('HTTP Error: ${response.statusCode}, ${response.body}');
    }
  }
}
