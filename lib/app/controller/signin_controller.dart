import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';
import '../../route/my_route.dart';
import '../controller/theme_controller.dart';

class SignInController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  final AuthController _authController = Get.find<AuthController>();

  // Form controllers
  TextEditingController? emailController;
  TextEditingController? passwordController;

  // UI State
  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  bool isIconTrue = true;
  bool isChecked = false;
  bool rememberMe = false;
  bool? checkBoxValue = false;

  // Focus nodes
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  // Form key
  final formKey = GlobalKey<FormState>();

  final BuildContext context;

  SignInController(this.context);

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _loadRememberedCredentials();
  }

  @override
  void onClose() {
    emailController?.dispose();
    passwordController?.dispose();
    f1.dispose();
    f2.dispose();
    super.onClose();
  }

  /// Load remembered credentials if available
  void _loadRememberedCredentials() {
    // You can implement this based on your secure storage needs
    // For now, just checking if user is already logged in
    if (_authController.isLoggedIn.value) {
      goToMainHomeScreen();
    }
  }

  /// Enhanced login method using AuthController
  Future<void> loginUser() async {
    final email = emailController?.text.trim() ?? '';
    final password = passwordController?.text ?? '';

    // Validate form
    if (formKey.currentState?.validate() != true) {
      return;
    }

    // Dismiss keyboard
    f1.unfocus();
    f2.unfocus();

    // Start loading
    isLoading.value = true;
    update();

    try {
      // Use AuthController's login method for token management
      await _authController.loginWithAPI(email, password);

      // Handle remember me functionality
      if (rememberMe) {
        await _handleRememberMe(email);
      }

      // Navigate to main screen
      goToMainHomeScreen();

      // Show success message
      Get.snackbar(
        'Success',
        'Welcome back!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Enhanced error handling
      _handleLoginError(e);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> signInWithGoogle() async {
    // Start Google loading state
    isGoogleLoading.value = true;
    update();

    try {
      print('🔄 Starting Google Sign-In from SignInController...');

      // Use AuthController's Google sign-in method
      await _authController.signInWithGoogle();
      // Navigate to main screen
      goToMainHomeScreen();
      // Show success message
      Get.snackbar(
        'Success',
        'Welcome! You\'ve signed in with Google.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 2),
      );

      // Navigation will be handled by the listener in onInit
      print('✅ Google Sign-In completed successfully');
    } catch (e) {
      print('❌ Google Sign-In failed in SignInController: $e');
      // Handle Google sign-in errors
      _handleGoogleSignInError(e);
    } finally {
      isGoogleLoading.value = false;
      update();
    }
  }

  /// Handle Google Sign-In specific errors
  void _handleGoogleSignInError(dynamic error) {
    String title = 'Google Sign-In Failed';
    String message = 'Unable to sign in with Google. Please try again.';

    // Remove "Exception: " prefix if present
    String errorMessage = error.toString().replaceFirst('Exception: ', '');

    // Handle different types of Google auth errors
    if (errorMessage.contains('network_error') ||
        errorMessage.contains('Network error')) {
      message = 'Network error. Please check your internet connection.';
    } else if (errorMessage.contains('sign_in_canceled') ||
        errorMessage.contains('Sign-in was canceled')) {
      message = 'Sign-in was canceled.';
      title = 'Sign-In Canceled';
    } else if (errorMessage
        .contains('account-exists-with-different-credential')) {
      message = 'An account already exists with a different sign-in method.';
    } else if (errorMessage.contains('invalid-credential')) {
      message = 'The credential is invalid or has expired.';
    } else if (errorMessage.contains('operation-not-allowed')) {
      message = 'Google sign-in is not enabled for this app.';
    } else if (errorMessage.contains('user-disabled')) {
      message = 'This user account has been disabled.';
    } else if (errorMessage.contains('Invalid Google authentication')) {
      message = 'Invalid Google authentication. Please try again.';
    } else if (errorMessage.contains('Account already exists')) {
      message = 'Account already exists with different credentials.';
    } else {
      message = errorMessage.isNotEmpty ? errorMessage : message;
    }

    // Only show error if it's not a user cancellation
    if (!errorMessage.contains('canceled') &&
        !errorMessage.contains('Sign-in was canceled')) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Handle remember me functionality
  Future<void> _handleRememberMe(String email) async {
    // You can implement secure storage for email here
    // Never store passwords for security reasons
    try {
      // Example: Store email in secure storage if needed
      // await _secureStorage.write(key: 'remembered_email', value: email);
    } catch (e) {
      // Handle storage error silently
    }
  }

  /// Enhanced error handling with user-friendly messages
  void _handleLoginError(dynamic error) {
    String title = 'Login Failed';
    String message = 'Please check your credentials and try again';

    // Handle different types of errors
    if (error.toString().contains('DioException') ||
        error.toString().contains('Network')) {
      message = 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('401') ||
        error.toString().contains('Invalid credentials')) {
      message = 'Invalid email or password. Please try again.';
    } else if (error.toString().contains('429')) {
      message = 'Too many login attempts. Please try again later.';
    } else if (error.toString().contains('500')) {
      message = 'Server error. Please try again later.';
    } else if (error.toString().contains('timeout')) {
      message = 'Request timeout. Please check your connection.';
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
    );
  }

  /// Enhanced password validation
  String? validate(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (value.length > 30) {
      return 'Password must be less than 30 characters';
    }
    return null;
  }

  /// Enhanced email validation
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter email';
    } else if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isIconTrue = !isIconTrue;
    update();
  }

  /// Toggle remember me
  void toggleRememberMe(bool value) {
    rememberMe = value;
    update();
  }

  /// Move focus to password field
  void moveToPasswordField() {
    f1.unfocus();
    f2.requestFocus();
  }

  /// Navigation methods
  void goToSignUpScreen() {
    Get.toNamed(MyRoutes.signup);
  }

  void goToMainHomeScreen() {
    Get.offNamedUntil(
      MyRoutes.mainDrawerScreen,
      (route) => false,
    );
  }

  void goToForgotPasswordScreen() {
    Get.toNamed(MyRoutes.resetPassword);
  }

  /// Quick login for testing or auto-login scenarios
  Future<void> quickLogin(String email, String password) async {
    emailController?.text = email;
    passwordController?.text = password;
    await loginUser();
  }

  /// Clear form data
  void clearForm() {
    emailController?.clear();
    passwordController?.clear();
    rememberMe = false;
    isIconTrue = true;
    update();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _authController.isLoggedIn.value;

  /// Get current user data
  Map<String, dynamic> get currentUser => _authController.userData;

  /// Check if user has specific role
  bool hasRole(String role) => _authController.hasRole(role);

  /// Logout method
  Future<void> logout() async {
    await _authController.logout();
    clearForm();
  }

  /// Check if any loading is in progress
  bool get isAnyLoading =>
      isLoading.value || isGoogleLoading.value || _authController.isLoading;
}
