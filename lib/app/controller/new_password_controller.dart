import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';



class NewPasswordController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool isIconTrue = true;
  bool isConPassIconTrue = true;
  bool isChecked = false;

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

  void goToNextScreen() {



   /* Get.offNamedUntil(
      '/signin/',
      (route) => false,
    );*/
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(),
    //   ),
    // );
  }
}
