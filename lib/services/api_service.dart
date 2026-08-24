import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_constants.dart';

class ApiService {
  Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    ).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to connect to server (${response.statusCode})",
    );
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
      },
    ).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to connect to server (${response.statusCode})",
    );
  }

  Future<dynamic> registerDevice({
    required String deviceToken,
    required String busId,
    required String boardingStop,
    required String destinationStop,
  }) async {
    return await post(
      "/bus/device/register",
      {
        "deviceToken": deviceToken,
        "busId": busId,
        "boardingStop": boardingStop,
        "destinationStop": destinationStop,
      },
    );
  }

  Future<dynamic> unsubscribeDevice({
    required String deviceToken,
    required String busId,
  }) async {
    return await post(
      "/bus/device/unsubscribe",
      {
        "deviceToken": deviceToken,
        "busId": busId,
      },
    );
  }
}