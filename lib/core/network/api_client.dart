import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/network_exception.dart';
import 'network_constants.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  // ------------------ GET ------------------
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).resolve(endpoint).replace(queryParameters: queryParams);
    final response = await _client.get(uri, headers: _buildHeaders(headers));
    return processResponse(response);
  }

  // ------------------ POST ------------------
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).resolve(endpoint).replace(queryParameters: queryParams);

    // print('➡️ POST request: $uri');
    // print('➡️ POST body: $body');

    final response = await _client.post(
      uri,
      headers: _buildHeaders(headers),
      body: _encodeBody(body),
    );
    return processResponse(response);
  }

  // ------------------ PUT ------------------
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).resolve(endpoint).replace(queryParameters: queryParams);

    final response = await _client.put(
      uri,
      headers: _buildHeaders(headers),
      body: _encodeBody(body),
    );
    return processResponse(response);
  }

  // ------------------ DELETE ------------------
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).resolve(endpoint).replace(queryParameters: queryParams);

    final request = http.Request("DELETE", uri)
      ..headers.addAll(_buildHeaders(headers));

    final encodedBody = _encodeBody(body);
    if (encodedBody != null) {
      request.body = encodedBody;
    }

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return processResponse(response);
  }

  // ------------------ PATCH ------------------
  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).resolve(endpoint).replace(queryParameters: queryParams);

    final response = await _client.patch(
      uri,
      headers: _buildHeaders(headers),
      body: _encodeBody(body),
    );
    return processResponse(response);
  }

  // ------------------ Helpers ------------------

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    return {
      HttpHeaders.contentTypeHeader: NetworkConstants.contentType,
      HttpHeaders.acceptHeader: NetworkConstants.accept,
      ...?headers,
    };
  }

  String? _encodeBody(dynamic body) {
    if (body == null) return null;
    try {
      return jsonEncode(body);
    } catch (_) {
      throw const NetworkException('Failed to encode request body');
    }
  }

  dynamic processResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return response.body.isEmpty ? null : jsonDecode(response.body);
      } catch (_) {
        throw const NetworkException('Invalid JSON response');
      }
    } else {
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        throw NetworkException(
          errorBody['message'] ?? 'Request failed',
          statusCode,
        );
      } catch (_) {
        throw NetworkException(
          'Request failed with status: $statusCode',
          statusCode,
        );
      }
    }
  }
}
