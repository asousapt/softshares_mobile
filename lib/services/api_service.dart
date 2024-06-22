import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Configure on dotenv file
  final String _baseUrl = (dotenv.env['API_URL'] as String);

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

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
        //Por enquanto não têm Bearer como prefix
        //'Authorization': 'Bearer $_authToken',
        'Authorization': '$_authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getRequestNoAuth(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
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
        'Authorization': '$_authToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

// makes a PUT request
  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
    if (_authToken == null) {
      throw Exception('Auth token is not set. Please authenticate first.');
    }
    print('$_baseUrl/$endpoint');
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$_authToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to put data');
    }
  }
}
