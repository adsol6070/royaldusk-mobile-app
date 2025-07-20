// services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:royaldusk_mobile_app/utils/api_response.dart';
import 'package:royaldusk_mobile_app/utils/app_constants.dart';
import 'package:royaldusk_mobile_app/utils/storage_helper.dart';

/// Base API service class that handles common HTTP operations
abstract class ApiService {
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const String _contentType = 'application/json';

  /// Base URL for API requests
  String get baseUrl => AppConstants.apiBaseUrl;

  /// Default headers for all requests
  Map<String, String> get defaultHeaders => {
        'Content-Type': _contentType,
        'Accept': _contentType,
      };

  /// Get authentication headers
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await StorageHelper.getAuthToken();
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }

  /// Combine default headers with auth headers
  Future<Map<String, String>> _buildHeaders(
      [Map<String, String>? additionalHeaders]) async {
    final headers = <String, String>{};
    headers.addAll(defaultHeaders);
    headers.addAll(await getAuthHeaders());

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Build complete URL with query parameters
  String _buildUrl(String endpoint, [Map<String, String>? queryParams]) {
    var url = baseUrl + endpoint;

    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      if (queryString.isNotEmpty) {
        url += '?$queryString';
      }
    }

    return url;
  }

  /// Handle HTTP response and convert to ApiResponse
  ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final body = response.body;
      Map<String, dynamic> data = {};

      if (body.isNotEmpty) {
        data = json.decode(body) as Map<String, dynamic>;
      }

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse.fromHttpResponse(
        isSuccess: isSuccess,
        statusCode: response.statusCode,
        data: data,
        message: data['message'] as String? ??
            _getDefaultMessage(response.statusCode),
        errorCode: data['errorCode'] as String?,
        meta: data['meta'] as Map<String, dynamic>?,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to parse response: $e',
        statusCode: response.statusCode,
      );
    }
  }

  /// Get default message based on status code
  String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'Request successful';
      case 201:
        return 'Created successfully';
      case 204:
        return 'No content';
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 422:
        return 'Validation error';
      case 500:
        return 'Internal server error';
      default:
        return 'Request failed';
    }
  }

  /// Handle network exceptions
  ApiResponse<Map<String, dynamic>> _handleException(dynamic exception) {
    if (exception is SocketException) {
      return ApiResponse.error(
        message: 'No internet connection',
        errorCode: 'NETWORK_ERROR',
      );
    } else if (exception is http.ClientException) {
      return ApiResponse.error(
        message: 'Connection timeout',
        errorCode: 'TIMEOUT_ERROR',
      );
    } else {
      return ApiResponse.error(
        message: 'An unexpected error occurred: $exception',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Perform GET request
  Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final requestHeaders = await _buildHeaders(headers);

      final response = await http
          .get(
            Uri.parse(url),
            headers: requestHeaders,
          )
          .timeout(timeout ?? _defaultTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// Perform POST request
  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final requestHeaders = await _buildHeaders(headers);

      final response = await http
          .post(
            Uri.parse(url),
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout ?? _defaultTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// Perform PUT request
  Future<ApiResponse<Map<String, dynamic>>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final requestHeaders = await _buildHeaders(headers);

      final response = await http
          .put(
            Uri.parse(url),
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout ?? _defaultTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// Perform PATCH request
  Future<ApiResponse<Map<String, dynamic>>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final requestHeaders = await _buildHeaders(headers);

      final response = await http
          .patch(
            Uri.parse(url),
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout ?? _defaultTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// Perform DELETE request
  Future<ApiResponse<Map<String, dynamic>>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final requestHeaders = await _buildHeaders(headers);

      final response = await http
          .delete(
            Uri.parse(url),
            headers: requestHeaders,
          )
          .timeout(timeout ?? _defaultTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// Upload file with multipart request
  Future<ApiResponse<Map<String, dynamic>>> uploadFile(
    String endpoint, {
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final requestHeaders = await _buildHeaders(headers);

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(requestHeaders)
        ..files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse =
          await request.send().timeout(timeout ?? _defaultTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// Download file
  Future<ApiResponse<List<int>>> downloadFile(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final requestHeaders = await _buildHeaders(headers);

      final response = await http
          .get(
            Uri.parse(url),
            headers: requestHeaders,
          )
          .timeout(timeout ?? _defaultTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(
          data: response.bodyBytes,
          message: 'File downloaded successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to download file',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to download file: $e',
        errorCode: 'DOWNLOAD_ERROR',
      );
    }
  }
}
