class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.royaldusk.com';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Default Values
  static const int defaultPageSize = 20;
  static const int maxRetryAttempts = 3;
  static const Duration defaultTimeout = Duration(seconds: 30);
}
