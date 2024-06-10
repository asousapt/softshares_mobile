import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://example.com:3000/api/v1";
  String? _authToken;

  // faz get no endpoint de autenticação
  Future<void> fetchAuthToken(
      String endpoint, Map<String, dynamic> credentials) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      _authToken =
          responseBody['token']; // Assuming the token is in the 'token' field
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  // FAz um GET request
  Future<dynamic> getRequest(String endpoint) async {
    if (_authToken == null) {
      throw Exception('Auth token is not set. Please authenticate first.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Makes a POST request
  Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    if (_authToken == null) {
      throw Exception('Auth token is not set. Please authenticate first.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}
