import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class ResetPasswordController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  TextEditingController? emailController;
  FocusNode f1 = FocusNode();
  final formKey = GlobalKey<FormState>();

  void goToVerifyScreen() {
    Get.toNamed(MyRoutes.otpVerify,arguments: [{'name':'reset_password'}]);

  }
}
