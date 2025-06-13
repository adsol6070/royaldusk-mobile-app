import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final dio.Dio _dio = dio.Dio();

  // Authentication state
  final RxBool isLoggedIn = false.obs;
  final RxString accessToken = ''.obs;
  final RxString refreshToken = ''.obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  // Additional state for better integration
  final RxBool isAuthenticating = false.obs;
  final RxBool isLoadingUserData = false.obs;
  final RxBool isSigningUp = false.obs; // New state for signup
  final RxString lastLoginError = ''.obs;
  final RxString lastSignupError = ''.obs; // New state for signup errors

  // Storage keys
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userDataKey = 'user_data';

  @override
  void onInit() {
    super.onInit();
    _loadTokens();
    _setupDioInterceptor();
  }

  void _loadTokens() async {
    try {
      final storedAccessToken = await _secureStorage.read(key: _accessTokenKey);
      final storedRefreshToken =
          await _secureStorage.read(key: _refreshTokenKey);

      if (storedAccessToken != null && !_isTokenExpired(storedAccessToken)) {
        accessToken.value = storedAccessToken;
        refreshToken.value = storedRefreshToken ?? '';
        isLoggedIn.value = true;

        // Fetch fresh user data from /me endpoint instead of decoding token
        await _fetchUserDataFromAPI();
      } else {
        await _clearAuthData();
      }
    } catch (e) {
      print('❌ Error loading tokens: $e');
      await _clearAuthData();
    }
  }

  /// Fetch user data from /me endpoint
  Future<void> _fetchUserDataFromAPI() async {
    if (accessToken.isEmpty) {
      return;
    }

    isLoadingUserData.value = true;

    try {
      final response = await _dio.get('/user-service/api/users/me');

      if (response.data != null) {
        // Access the response data correctly as a Map
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['status'] == 'success' &&
            responseData['data'] != null &&
            responseData['data']['user'] != null) {
          final userDataFromAPI =
              responseData['data']['user'] as Map<String, dynamic>;

          // Store user data in memory
          userData.assignAll(userDataFromAPI);

          // Optionally store in secure storage for offline access
          await _storeUserDataLocally(userDataFromAPI);
        } else {
          throw Exception('Invalid response structure from /me endpoint');
        }
      } else {
        throw Exception('Empty response from server');
      }
    } catch (e) {
      print('❌ Error fetching user data: $e');
      print('Error type: ${e.runtimeType}');

      // Try to load cached user data if API call fails
      await _loadCachedUserData();

      // If this is a 401 error, the token might be invalid
      if (e is dio.DioException && e.response?.statusCode == 401) {
        print('🔄 Attempting token refresh due to 401 error...');
        final refreshed = await _refreshAccessToken();
        if (!refreshed) {
          print('❌ Token refresh failed, logging out...');
          await logout();
        } else {
          // Retry fetching user data after successful refresh
          await _fetchUserDataFromAPI();
        }
      }
    } finally {
      isLoadingUserData.value = false;
    }
  }

  /// Store user data locally for offline access
  Future<void> _storeUserDataLocally(
      Map<String, dynamic> userDataToStore) async {
    try {
      // Convert the user data to JSON string for proper storage
      final jsonString = jsonEncode(userDataToStore);
      await _secureStorage.write(key: _userDataKey, value: jsonString);
    } catch (e) {
      print('⚠️ Failed to cache user data: $e');
    }
  }

  /// Load cached user data when API is unavailable
  Future<void> _loadCachedUserData() async {
    try {
      final cachedData = await _secureStorage.read(key: _userDataKey);
      if (cachedData != null) {
        // Parse the JSON string back to Map
        final cachedUserData = jsonDecode(cachedData) as Map<String, dynamic>;
        userData.assignAll(cachedUserData);
      } else {
        print('📱 No cached user data available');
      }
    } catch (e) {
      print('⚠️ Failed to load cached user data: $e');
    }
  }

  bool _isTokenExpired(String token) {
    try {
      return Jwt.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  void _setupDioInterceptor() {
    _dio.interceptors.clear();

    // Add base URL and default headers
    _dio.options.baseUrl = 'https://api.royaldusk.com';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${accessToken.value}';
          }
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
        onError: (dio.DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains('/auth/login') &&
              !e.requestOptions.path.contains('/auth/register') &&
              !e.requestOptions.path.contains('/me')) {
            final success = await _refreshAccessToken();
            if (success) {
              final clonedRequest = await _retryRequest(e.requestOptions);
              return handler.resolve(clonedRequest);
            } else {
              await logout();
              return handler.reject(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<dio.Response<dynamic>> _retryRequest(
      dio.RequestOptions requestOptions) async {
    final options = dio.Options(
        method: requestOptions.method, headers: requestOptions.headers);
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<bool> _refreshAccessToken() async {
    if (refreshToken.isEmpty) return false;

    try {
      final response = await _dio.post('/api/refresh', data: {
        'refresh_token': refreshToken.value,
      });

      final newToken = response.data['access_token'];
      final newRefresh = response.data['refresh_token'];

      if (newToken != null) {
        await _storeTokens(newToken, newRefresh);

        // Fetch fresh user data with new token
        await _fetchUserDataFromAPI();

        return true;
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
    }
    return false;
  }

  /// Enhanced signup method with comprehensive error handling
  Future<void> signupWithAPI(String name, String email, String password) async {
    // Validate input
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Name, email and password are required');
    }

    if (!GetUtils.isEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    isSigningUp.value = true;
    lastSignupError.value = '';

    try {
      final response =
          await _dio.post('/user-service/api/auth/register', data: {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      });

      // Handle different response structures
      if (response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if signup was successful
        if (responseData['status'] == 'success' ||
            response.statusCode == 201 ||
            response.statusCode == 200) {
          // Check if tokens are provided immediately (auto-login after signup)
          final access = responseData['access_token'];
          final refresh = responseData['refresh_token'];

          if (access != null) {
            print('🔑 Tokens received, logging in user automatically...');
            await _storeTokens(access, refresh);
            await _fetchUserDataFromAPI();
            print('✅ Auto-login completed');
          } else {
            print('📧 Signup successful, user needs to verify/login manually');
            // No auto-login, user might need to verify email or login manually
          }
        } else {
          // Handle error response from server
          final errorMessage = responseData['message'] ??
              responseData['error'] ??
              'Signup failed. Please try again.';
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Invalid response from server');
      }
    } on dio.DioException catch (e) {
      print('❌ Dio Exception during signup');
      print('📊 Status code: ${e.response?.statusCode}');
      print('📦 Error response: ${e.response?.data}');

      String errorMessage = _parseSignupError(e);
      lastSignupError.value = errorMessage;
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Unexpected error during signup: $e');
      lastSignupError.value = 'An unexpected error occurred';
      throw Exception('Signup failed: ${e.toString()}');
    } finally {
      isSigningUp.value = false;
    }
  }

  /// Parse signup-specific errors
  String _parseSignupError(dio.DioException e) {
    if (e.response?.data != null) {
      final errorData = e.response!.data;

      // Handle structured error responses
      if (errorData is Map<String, dynamic>) {
        if (errorData['message'] != null) {
          return errorData['message'].toString();
        }
        if (errorData['error'] != null) {
          return errorData['error'].toString();
        }
        if (errorData['errors'] != null) {
          // Handle validation errors
          if (errorData['errors'] is Map) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return firstError.toString();
          }
        }
      }
    }

    // Handle HTTP status codes
    switch (e.response?.statusCode) {
      case 400:
        return 'Invalid signup data. Please check your information.';
      case 409:
      case 422:
        return 'Email already exists. Please use a different email or try logging in.';
      case 429:
        return 'Too many signup attempts. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return _parseDioError(e); // Fall back to general error parsing
    }
  }

  /// Enhanced login method with better error handling
  Future<void> loginWithAPI(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    isAuthenticating.value = true;
    lastLoginError.value = '';

    try {
      final response = await _dio.post('/user-service/api/auth/login', data: {
        'email': email,
        'password': password,
      });

      final access = response.data['access_token'];
      final refresh = response.data['refresh_token'];

      if (access != null) {
        await _storeTokens(access, refresh);
        await _fetchUserDataFromAPI();
      } else {
        throw Exception('Invalid response from server');
      }
    } on dio.DioException catch (e) {
      String errorMessage = _parseDioError(e);
      lastLoginError.value = errorMessage;
      throw Exception(errorMessage);
    } catch (e) {
      lastLoginError.value = 'An unexpected error occurred';
      throw Exception('Login failed: ${e.toString()}');
    } finally {
      isAuthenticating.value = false;
    }
  }

  /// Parse Dio errors into user-friendly messages
  String _parseDioError(dio.DioException e) {
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case dio.DioExceptionType.connectionError:
        return 'Network error. Please check your internet connection.';
      case dio.DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            return 'Invalid email or password format';
          case 401:
            return 'Invalid email or password';
          case 429:
            return 'Too many login attempts. Please try again later.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Login failed. Please try again.';
        }
      default:
        return 'An unexpected error occurred';
    }
  }

  Future<void> _storeTokens(String access, String? refresh) async {
    accessToken.value = access;
    refreshToken.value = refresh ?? '';
    isLoggedIn.value = true;

    await _secureStorage.write(key: _accessTokenKey, value: access);
    if (refresh != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refresh);
    }
  }

  /// Clear authentication data
  Future<void> _clearAuthData() async {
    accessToken.value = '';
    refreshToken.value = '';
    userData.clear();
    isLoggedIn.value = false;
    lastLoginError.value = '';
    lastSignupError.value = '';
  }

  /// Enhanced logout with proper cleanup
  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint to invalidate token on server
      if (accessToken.isNotEmpty) {
        try {
          await _dio.post('/api/logout', data: {
            'token': accessToken.value,
          });
          print('✅ Logout API call successful');
        } catch (e) {
          print('⚠️ Logout endpoint failed, continuing with local cleanup: $e');
        }
      }
    } catch (e) {
      print('⚠️ Error during logout API call: $e');
    }

    // Clear local storage
    await _secureStorage.deleteAll();
    await _clearAuthData();

    Get.offAllNamed('/signin');
  }

  /// Manually refresh user data
  Future<void> refreshUserData() async {
    await _fetchUserDataFromAPI();
  }

  /// Validate signup input
  Map<String, String?> validateSignupInput(
      String name, String email, String password, String confirmPassword) {
    Map<String, String?> errors = {};

    if (name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    } else if (name.trim().length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    }

    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!GetUtils.isEmail(email.trim())) {
      errors['email'] = 'Please enter a valid email address';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    } else if (password.length > 50) {
      errors['password'] = 'Password must be less than 50 characters';
    }

    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Please confirm your password';
    } else if (password != confirmPassword) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    return errors;
  }

  /// Check if user has specific role
  bool hasRole(String role) {
    return userData['role'] == role ||
        userData['roles']?.contains(role) == true;
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<String> roles) {
    return roles.any((role) => hasRole(role));
  }

  /// Get user's display name
  String get displayName {
    return userData['name'] ??
        userData['username'] ??
        userData['display_name'] ??
        userData['first_name'] ??
        userData['email'] ??
        'User';
  }

  /// Get user's email
  String get userEmail {
    return userData['email'] ?? '';
  }

  /// Get user's ID
  String get userId {
    return userData['id']?.toString() ??
        userData['user_id']?.toString() ??
        userData['_id']?.toString() ??
        '';
  }

  /// Get user's profile picture
  String get profilePicture {
    return userData['profile_picture'] ??
        userData['avatar'] ??
        userData['image'] ??
        '';
  }

  /// Get user's phone number
  String get phoneNumber {
    return userData['phone'] ??
        userData['phone_number'] ??
        userData['mobile'] ??
        '';
  }

  /// Validate current session
  bool get isValidSession {
    return isLoggedIn.value &&
        accessToken.isNotEmpty &&
        !_isTokenExpired(accessToken.value);
  }

  // Getters for external access
  dio.Dio get dioClient => _dio;
  String? get currentToken =>
      accessToken.value.isNotEmpty ? accessToken.value : null;
  bool get isLoading =>
      isAuthenticating.value || isLoadingUserData.value || isSigningUp.value;
}
