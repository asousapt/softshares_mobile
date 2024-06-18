import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //Android emulators use a special network address (10.0.2.2) to refer to your computer's localhost.
  //final String _baseUrl = "http://192.168.1.84:8000";
  final String _baseUrl = "http://10.0.2.2:8000";
  /*Quando já tivermos o servidor online mudamos
  final String _baseUrl = "http://endereço do servidor";*/
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
      print("Devolve dados");
      return json.decode(response.body);
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
}
