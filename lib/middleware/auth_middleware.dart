import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';

/// Middleware to protect routes that require authentication
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    print('🔒 AuthMiddleware: Checking auth for route: $route');

    final authController = Get.find<AuthController>();

    // Check if user is authenticated
    if (!authController.isLoggedIn.value || !authController.isValidSession) {
      print('❌ User not authenticated, redirecting to login');
      return const RouteSettings(name: '/signin');
    }

    print('✅ User authenticated, allowing access to: $route');
    return null; // Allow access
  }
}

/// Middleware to prevent authenticated users from accessing auth screens
class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    print('👤 GuestMiddleware: Checking guest access for route: $route');

    final authController = Get.find<AuthController>();

    // If user is already logged in, redirect to main screen
    if (authController.isLoggedIn.value && authController.isValidSession) {
      print('✅ User already logged in, redirecting to main screen');
      return const RouteSettings(name: '/main_drawer_screen');
    }

    print('👤 User not logged in, allowing access to: $route');
    return null; // Allow access to auth screens
  }
}

/// Middleware for role-based access control
class RoleMiddleware extends GetMiddleware {
  final List<String> requiredRoles;

  RoleMiddleware({required this.requiredRoles});

  @override
  int? get priority => 2; // Execute after AuthMiddleware

  @override
  RouteSettings? redirect(String? route) {
    print('👔 RoleMiddleware: Checking roles for route: $route');
    print('Required roles: $requiredRoles');

    final authController = Get.find<AuthController>();

    // First check if user is authenticated
    if (!authController.isLoggedIn.value || !authController.isValidSession) {
      print('❌ User not authenticated');
      return const RouteSettings(name: '/signin');
    }

    // Check if user has required roles
    final hasRequiredRole = authController.hasAnyRole(requiredRoles);

    if (!hasRequiredRole) {
      print('❌ User does not have required roles');
      print(
          'User roles: ${authController.userData['roles'] ?? authController.userData['role']}');

      // Redirect to unauthorized page or main screen
      Get.snackbar(
        'Access Denied',
        'You do not have permission to access this page',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return const RouteSettings(name: '/main_drawer_screen');
    }

    print('✅ User has required roles, allowing access');
    return null; // Allow access
  }
}
