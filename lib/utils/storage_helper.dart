import 'package:royaldusk_mobile_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Auth Token Management
  static Future<String?> getAuthToken() async {
    final prefs = await _instance;
    return prefs.getString(AppConstants.authTokenKey);
  }

  static Future<bool> setAuthToken(String token) async {
    final prefs = await _instance;
    return prefs.setString(AppConstants.authTokenKey, token);
  }

  static Future<bool> removeAuthToken() async {
    final prefs = await _instance;
    return prefs.remove(AppConstants.authTokenKey);
  }

  // Refresh Token Management
  static Future<String?> getRefreshToken() async {
    final prefs = await _instance;
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  static Future<bool> setRefreshToken(String token) async {
    final prefs = await _instance;
    return prefs.setString(AppConstants.refreshTokenKey, token);
  }

  static Future<bool> removeRefreshToken() async {
    final prefs = await _instance;
    return prefs.remove(AppConstants.refreshTokenKey);
  }

  // Generic Storage Methods
  static Future<T?> get<T>(String key) async {
    final prefs = await _instance;
    final value = prefs.get(key);
    return value as T?;
  }

  static Future<bool> set<T>(String key, T value) async {
    final prefs = await _instance;

    if (value is String) {
      return prefs.setString(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is List<String>) {
      return prefs.setStringList(key, value);
    } else {
      // For complex objects, store as JSON string
      return prefs.setString(key, json.encode(value));
    }
  }

  static Future<bool> remove(String key) async {
    final prefs = await _instance;
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    final prefs = await _instance;
    return prefs.clear();
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }

  // User Data Management
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _instance;
    final userData = prefs.getString(AppConstants.userDataKey);
    if (userData != null) {
      return json.decode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> setUserData(Map<String, dynamic> userData) async {
    final prefs = await _instance;
    return prefs.setString(AppConstants.userDataKey, json.encode(userData));
  }

  static Future<bool> removeUserData() async {
    final prefs = await _instance;
    return prefs.remove(AppConstants.userDataKey);
  }
}
