import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../route/my_route.dart';
import '../controller/theme_controller.dart';


class SignInController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

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



  validate(String value) {
    if (value.length < 8) {
      return 'password must be more than 8 character';
    } else if (value.length > 16) {
      return 'password must be  less than 16 character';
    } else if (value.isEmpty) {
      return 'Please enter password';
    }
  }

  void goToSignUpScreen() {
    Get.toNamed(MyRoutes.signup);

  }

  void goToMainHomeScreen() {
    Get.offNamedUntil(MyRoutes.mainDrawerScreen,(route) => false,);
  }

  void goToForgotPasswordScreen() {
    Get.toNamed(MyRoutes.resetPassword);

  }
}