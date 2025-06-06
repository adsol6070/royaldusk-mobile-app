import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class SignUpController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController passwordController= TextEditingController();
  TextEditingController? confirmPasswordController;

  bool isIconTrue = false;
  bool isConPassIconTrue = false;
  bool isChecked = false;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  bool rememberMe = false;

  final formKey = GlobalKey<FormState>();


  bool? checkBoxValue = false;

  final BuildContext context;

  SignUpController(this.context);

  void goToBackScreen() {
    Get.back();
  }

  void goToOtpScreen(String name) {
    Get.offNamed(MyRoutes.otpVerify,arguments: [ {"name": name},]);
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(),
    //   ),
    // );
  }

  confirmPasswordValidate(String value) {
    if (value.length < 8) {
      return 'password must be more than 8 character';
    } else if (value.length > 16) {
      return 'password must be  less than 16 character';
    } else if (value.isEmpty) {
      return 'Please enter password';
    } else if (value != passwordController.text) {
      return 'password must match';
    } else {
      return null;
    }
  }

  validate(String value) {
    if (value.length < 8) {
      return 'password must be more than 8 character';
    } else if (value.length > 16) {
      return 'password must be  less than 16 character';
    } else if (value.isEmpty) {
      return 'Please enter password';
    }
  }

  validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter fullName';
    }
  }
}
