import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter/material.dart";

class ApiService {
  final String _baseUrl = dotenv.env['API_URL'] as String;
  String? _authToken;

  ApiService() {
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token');

    if (_authToken == null || _authToken!.isEmpty) {
      String? utilizadorObj = prefs.getString('utilizadorObj');
      if (utilizadorObj == null || utilizadorObj.isEmpty) {
        // Handle the case where utilizadorObj is empty
        // For example, fetch credentials from the user input or parameter
        print("Utilizador object is empty. Please provide credentials.");
      } else {
        Map<String, dynamic> credentials = json.decode(utilizadorObj);
        await fetchAuthToken(credentials);
      }
    }
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> fetchAuthToken(Map<String, dynamic> credentials) async {
    final prefs = await SharedPreferences.getInstance();
    final tipo = await prefs.getString("tipoLogin");
    Map <String, dynamic> dados = {
      "email" : credentials["email"],
      "tipo" : tipo,
    };

    if(tipo == "normal"){
      final pass = await prefs.getString("pass");
      dados['pass'] = pass;
    }else if(tipo == "google"){
      final token = await prefs.getString("googletoken");
      dados['token'] = token;
    }else if(tipo == "facebook"){
      final token = await prefs.getString("facebooktoken");
      dados['token'] = token;
    }

    print("endereço: $_baseUrl/utilizadores/login\ndados: ${json.encode(dados)}");

    final response = await postRequestNoAuth('utilizadores/login', dados);

    if (response['message']) {
      print(response.body);
      final responseBody = json.decode(response.body);
      await setAuthToken(responseBody['token']);
      await prefs.setString(
          'utilizadorObj', jsonEncode(responseBody['utilizador']));
    } else {
      print(response.body);

      throw Exception('Failed to authenticate');
    }
  }

  Future<void> fetchAuthTokenWithFallback(
      Map<String, dynamic> fallbackCredentials) async {
    final prefs = await SharedPreferences.getInstance();
    String? utilizadorObj = prefs.getString('utilizadorObj');
    Map<String, dynamic> credentials;

    if (utilizadorObj == null || utilizadorObj.isEmpty) {
      credentials = fallbackCredentials;
    } else {
      credentials = json.decode(utilizadorObj);
    }
    await fetchAuthToken(credentials);
  }

  Future<dynamic> getRequest(String endpoint) async {
    if (_authToken == null) {
      throw Exception('Auth token is not set. Please authenticate first.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Authorization': '$_authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('$_baseUrl/$endpoint');
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

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    if (_authToken == null) {
      throw Exception('Auth token is not set. Please authenticate first.');
    }
    print('$_baseUrl/$endpoint');
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
      print(json.decode(response.body));
      throw Exception('Failed to post data');
    }
  }

  Future<dynamic> postRequestNoAuth(String endpoint, Map<String, dynamic> data) async {
    print('$_baseUrl/$endpoint');
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw Exception('Failed to post data');
    }
  }

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

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw Exception('Failed to put data');
    }
  }

  Future<dynamic> deleteRequest(String endpoint) async {
    if (_authToken == null) {
      throw Exception('Auth token is not set. Please authenticate first.');
    }
    print('$_baseUrl/$endpoint');
    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$_authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }
}