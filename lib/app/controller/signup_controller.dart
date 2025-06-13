import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';
import '../controller/theme_controller.dart';

class SignUpController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  final AuthController _authController = Get.find<AuthController>();

  // Form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // UI state
  final RxBool isIconTrue = false.obs;
  final RxBool isConPassIconTrue = false.obs;
  final RxBool isChecked = false.obs;
  final RxBool rememberMe = false.obs;

  // Focus nodes
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  // Form key
  final formKey = GlobalKey<FormState>();

  final BuildContext context;

  SignUpController(this.context);

  @override
  void onInit() {
    super.onInit();
    print('🔧 SignUpController initialized');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    super.onClose();
  }

  /// Main signup method using AuthController
  /// Main signup method using AuthController
  Future<void> signUpUser() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    // Check terms acceptance
    if (!isChecked.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms and conditions to continue',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Dismiss keyboard
    _dismissKeyboard();

    try {
      print('🚀 Starting signup process...');

      // Use AuthController's signup method
      await _authController.signupWithAPI(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );

      print('✅ Signup API call completed successfully');

      // Handle successful signup - check auth status after a brief delay
      // to allow any auto-login process to complete
      await Future.delayed(const Duration(milliseconds: 100));
      await _handleSignupSuccess();
    } catch (e) {
      print('❌ Signup failed: $e');
      _handleSignupError(e.toString());
    }
  }

  /// Handle successful signup
  Future<void> _handleSignupSuccess() async {
    print('✅ Signup successful, handling success...');
    print('🔍 Checking authentication status...');
    print('- isLoggedIn: ${_authController.isLoggedIn.value}');
    print(
        '- accessToken: ${_authController.accessToken.value.isNotEmpty ? "present" : "absent"}');
    print(
        '- userData: ${_authController.userData.isNotEmpty ? "loaded" : "empty"}');

    // Clear form first
    _clearForm();

    // Give a moment for any auth state changes to propagate
    await Future.delayed(const Duration(milliseconds: 200));

    // Re-check authentication status
    final isAuthenticated = _authController.isLoggedIn.value &&
        _authController.accessToken.value.isNotEmpty;

    if (isAuthenticated) {
      print('🔑 User is authenticated, navigating to main screen');

      // User is logged in, go to main screen
      Get.offAllNamed(MyRoutes.mainDrawerScreen);

      // Show welcome message after navigation
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.snackbar(
          'Welcome!',
          'Account created successfully. Welcome to Royal Dusk, ${_authController.displayName}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      });
    } else {
      print('📧 Manual login required, navigating to sign in screen');

      // Manual login required, go to login screen
      Get.offAllNamed(MyRoutes.signIn);

      // Show success message after navigation
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.snackbar(
          'Account Created Successfully',
          'Your account has been created. Please sign in to continue.',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
          icon: const Icon(Icons.email, color: Colors.white),
        );
      });
    }
  }

  /// Handle signup errors with better error categorization
  void _handleSignupError(String error) {
    print('❌ Handling signup error: $error');

    // Clean up error message
    String cleanError = error.replaceAll('Exception: ', '');

    // Categorize error for better user experience
    String title = 'Signup Failed';
    Color backgroundColor = Colors.red;
    IconData icon = Icons.error;

    if (cleanError.toLowerCase().contains('email already exists') ||
        cleanError.toLowerCase().contains('already registered')) {
      title = 'Email Already Registered';
      backgroundColor = Colors.orange;
      icon = Icons.email;
    } else if (cleanError.toLowerCase().contains('network') ||
        cleanError.toLowerCase().contains('connection')) {
      title = 'Connection Error';
      icon = Icons.wifi_off;
    } else if (cleanError.toLowerCase().contains('server') ||
        cleanError.toLowerCase().contains('timeout')) {
      title = 'Server Error';
      icon = Icons.cloud_off;
    }

    Get.snackbar(
      title,
      cleanError,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      icon: Icon(icon, color: Colors.white),
    );
  }

  /// Enhanced validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }
    // Optional: Add more password strength requirements
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// UI helper methods
  void togglePasswordVisibility() {
    isIconTrue.value = !isIconTrue.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConPassIconTrue.value = !isConPassIconTrue.value;
    update();
  }

  void toggleTermsAcceptance(bool? value) {
    isChecked.value = value ?? false;
    update();
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
    update();
  }

  /// Focus management
  void moveToEmail() {
    f1.unfocus();
    f2.requestFocus();
  }

  void moveToPassword() {
    f2.unfocus();
    f3.requestFocus();
  }

  void moveToConfirmPassword() {
    f3.unfocus();
    f4.requestFocus();
  }

  void _dismissKeyboard() {
    f1.unfocus();
    f2.unfocus();
    f3.unfocus();
    f4.unfocus();
  }

  /// Form management
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isChecked.value = false;
    rememberMe.value = false;
    isIconTrue.value = false;
    isConPassIconTrue.value = false;
  }

  /// Navigation methods
  void goToBackScreen() {
    Get.back();
  }

  void goToSignInScreen() {
    Get.offNamed(MyRoutes.signIn);
  }

  void goToTermsAndConditions() {
    Get.toNamed('/terms-and-conditions');
  }

  void goToPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  /// Quick access to loading state
  bool get isLoading => _authController.isSigningUp.value;

  /// Check if all required fields are filled
  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        isChecked.value;
  }

  /// Get current signup error
  String get signupError => _authController.lastSignupError.value;

  // Legacy methods for backward compatibility (if needed)
  @deprecated
  void goToOtpScreen(String name) {
    // This method is deprecated, signup now handles navigation automatically
    print('⚠️ goToOtpScreen is deprecated, using automatic navigation instead');
  }

  @deprecated
  String? validate(String value) {
    return validatePassword(value);
  }

  @deprecated
  String? confirmPasswordValidate(String value) {
    return validateConfirmPassword(value);
  }
}
