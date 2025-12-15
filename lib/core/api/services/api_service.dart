import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://baseUrl.com';
  static const String accountsBaseUrl =
      'https://excel-accounts-backend-1024858294879.asia-south1.run.app/api';
  static const String eventsTestingUrl = 'https://excel-events-service-1024858294879.asia-south1.run.app/api';

  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// GET request
  static Future<dynamic> get(
    String endpoint, {
    String baseUrl = _baseUrl,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);
    final response = await http.get(uri, headers: headers ?? defaultHeaders);
    return _handleResponse(response);
  }

  /// POST request
  static Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse(_baseUrl + endpoint);
    final response = await http.post(
      uri,
      headers: headers ?? defaultHeaders,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// PUT request
  static Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse(_baseUrl + endpoint);
    final response = await http.put(
      uri,
      headers: headers ?? defaultHeaders,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// DELETE request
  static Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse(_baseUrl + endpoint);
    final request = http.Request('DELETE', uri);
    request.headers.addAll(headers ?? defaultHeaders);
    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  /// PATCH request
  static Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse(_baseUrl + endpoint);
    final response = await http.patch(
      uri,
      headers: headers ?? defaultHeaders,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// Centralized response handler
  static dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    try {
      final decoded = body.isNotEmpty ? jsonDecode(body) : null;

      if (statusCode >= 200 && statusCode < 300) {
        return decoded;
      } else {
        throw HttpException(
          message: decoded?['message'] ?? 'Unknown error',
          statusCode: statusCode,
        );
      }
    } catch (e) {
      throw HttpException(
        message: 'Failed to parse response',
        statusCode: statusCode,
      );
    }
  }
}

/// Custom exception for API errors
class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException({required this.message, required this.statusCode});

  @override
  String toString() => 'HttpException: $message (Status code: $statusCode)';
}
