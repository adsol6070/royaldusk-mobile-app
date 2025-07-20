import 'package:http/http.dart' as http;
import 'package:royaldusk_mobile_app/utils/app_constants.dart';
import 'package:royaldusk_mobile_app/utils/storage_helper.dart';
import 'dart:convert';

class ApiInterceptor {
  static Future<http.Response> handleRequest(
      Future<http.Response> Function() request,
      {bool requiresAuth = true}) async {
    try {
      final response = await request();

      // Handle token refresh if needed
      if (response.statusCode == 401 && requiresAuth) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          return await request();
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await StorageHelper.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await StorageHelper.setAuthToken(data['accessToken']);
        if (data['refreshToken'] != null) {
          await StorageHelper.setRefreshToken(data['refreshToken']);
        }
        return true;
      }
    } catch (e) {
      // Handle refresh token error
      await StorageHelper.removeAuthToken();
      await StorageHelper.removeRefreshToken();
    }

    return false;
  }
}
