import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_constants.dart';

class ApiService {
  Future<dynamic> post(String endpoint, Map<String, dynamic> body,) async {
    final response = await http.post(Uri.parse(ApiConstants.baseUrl + endpoint,),
      headers: {"Content-Type": "application/json",},
      body: jsonEncode(body),).timeout(
      const Duration(seconds: 15),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(
      "Failed to connect to server (${response.statusCode})",
    );
  }
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse(ApiConstants.baseUrl + endpoint,),
      headers: {"Content-Type": "application/json",},).timeout(
      const Duration(seconds: 15),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(
      "Failed to connect to server (${response.statusCode})",
    );
  }
}