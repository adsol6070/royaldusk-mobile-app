import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../route/my_route.dart';
import '../controller/theme_controller.dart';
import '../../httpClient/http_client.dart';

class SignInController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final ApiClient apiClient = ApiClient();

  TextEditingController? emailController;
  TextEditingController? passwordController;

  bool isIconTrue = true;
  bool isChecked = false;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  bool rememberMe = false;

  final formKey = GlobalKey<FormState>();

  bool? checkBoxValue = false;

  final BuildContext context;

  SignInController(this.context);

   @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.onClose();
  }

  validate(String value) {
    if (value.length < 8) {
      return 'password must be more than 8 character';
    } else if (value.length > 16) {
      return 'password must be  less than 16 character';
    } else if (value.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  Future<void> loginUser() async {
    final email = emailController?.text ?? '';
    final password = passwordController?.text ?? '';

    if (formKey.currentState?.validate() != true) return;

    try {
      final response = await apiClient.post(
        '/user-service/api/auth/login',
        {'email': email, 'password': password},
      );

      // final body = jsonDecode(response.body);
      goToMainHomeScreen();
    } catch (e) {
      // print('Login Failed: $e');
      Get.snackbar('Login Failed', e.toString());
    }
  }

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
}
