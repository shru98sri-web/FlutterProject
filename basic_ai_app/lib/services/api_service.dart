import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ApiService {
  final String baseUrl;

  ApiService({
    this.baseUrl = AppConstants.baseUrl,
  });

  Future<Map<String, dynamic>> get(
    String endpoint,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(AppConstants.requestTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception(
        'Unable to connect to server: $e',
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception(
        'Unable to connect to server: $e',
      );
    }
  }

  Map<String, dynamic> _handleResponse(
    http.Response response,
  ) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Invalid response from server',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Map<String, dynamic>.from(decoded);
    }

    String message = 'Request failed';

    if (decoded is Map && decoded['detail'] != null) {
      message = decoded['detail'].toString();
    }

    throw Exception(
      '$message (${response.statusCode})',
    );
  }
}
