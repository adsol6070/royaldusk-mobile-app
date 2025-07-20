import 'package:royaldusk_mobile_app/services/api_service.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';
import 'package:royaldusk_mobile_app/utils/api_response.dart';

abstract class ProtectedApiService extends ApiService {
  final AuthService _authService = AuthService();

  @override
  Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeAuthenticatedRequest(() => super.get(
          endpoint,
          queryParams: queryParams,
          headers: headers,
          timeout: timeout,
        ));
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeAuthenticatedRequest(() => super.post(
          endpoint,
          body: body,
          headers: headers,
          timeout: timeout,
        ));
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeAuthenticatedRequest(() => super.put(
          endpoint,
          body: body,
          headers: headers,
          timeout: timeout,
        ));
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeAuthenticatedRequest(() => super.patch(
          endpoint,
          body: body,
          headers: headers,
          timeout: timeout,
        ));
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeAuthenticatedRequest(() => super.delete(
          endpoint,
          headers: headers,
          timeout: timeout,
        ));
  }

  // Handle authenticated requests with token refresh
  Future<ApiResponse<Map<String, dynamic>>> _makeAuthenticatedRequest(
    Future<ApiResponse<Map<String, dynamic>>> Function() request,
  ) async {
    // First attempt
    var response = await request();

    // If unauthorized, try to refresh token and retry
    if (response.statusCode == 401) {
      // final refreshResponse = await _authService.refreshToken();

      // if (refreshResponse.isSuccess) {
      //   // Retry the original request with new token
      //   response = await request();
      // } else {
      //   // Refresh failed, user needs to login again
      //   await _authService.logout();
      //   return ApiResponse.error(
      //     message: 'Session expired. Please login again.',
      //     errorCode: 'SESSION_EXPIRED',
      //     statusCode: 401,
      //   );
      // }
    }

    return response;
  }
}
