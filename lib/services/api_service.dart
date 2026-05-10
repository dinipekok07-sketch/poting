import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pemilihan_ketua_kelas_informatika/utils/constants.dart';
import 'package:pemilihan_ketua_kelas_informatika/utils/exceptions.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseUrl;

  // GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(AppConstants.timeoutDuration);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // POST request
  static Future<dynamic> post(
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
            body: _encodeBody(body),
          )
          .timeout(AppConstants.timeoutDuration);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // PUT request
  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: _encodeBody(body),
          )
          .timeout(AppConstants.timeoutDuration);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // DELETE request
  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(AppConstants.timeoutDuration);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // Handle response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      throw AppException(
        message: 'Unauthorized',
        code: 'UNAUTHORIZED',
      );
    } else if (response.statusCode == 403) {
      throw AppException(
        message: 'Forbidden',
        code: 'FORBIDDEN',
      );
    } else if (response.statusCode == 404) {
      throw AppException(
        message: 'Not found',
        code: 'NOT_FOUND',
      );
    } else if (response.statusCode == 500) {
      throw AppException(
        message: 'Internal server error',
        code: 'SERVER_ERROR',
      );
    } else {
      throw AppException(
        message: 'Unknown error',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  // Encode body
  static String _encodeBody(Map<String, dynamic> body) {
    return jsonEncode(body);
  }
}

// Extension for handling JSON
extension ResponseExtension on http.Response {
  Map<String, dynamic> parseJson() {
    return jsonDecode(body);
  }

  List<dynamic> parseJsonArray() {
    final json = jsonDecode(body);
    return json is List ? json : [];
  }
}

