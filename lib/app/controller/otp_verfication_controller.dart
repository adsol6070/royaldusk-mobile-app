import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class OtpVerificationController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  final RxList<String> otpValues = List.generate(4, (index) => '').obs;


  final formKey = GlobalKey<FormState>();

  List<FocusNode> nodes = [];
  List<TextEditingController> listController = [];

  dynamic argumentData = Get.arguments;

  @override
  void onInit() {
    // print(argumentData[0]['name']);
    super.onInit();
  }

  void goToBackScreen() {
    Get.back();
  }

  bool validateOtp() {
    for (int i = 0; i < otpValues.length; i++) {
      if (otpValues[i].isEmpty) {
        Get.snackbar('Error', 'Please enter all digits');
        return false;
      }
    }
    return true;
  }

  void goToNextScreen() {
    if (argumentData[0]['name'] == 'signup') {
      Get.offNamedUntil(MyRoutes.mainDrawerScreen, (route) => false);
    } else if (argumentData[0]['name'] == 'reset_password') {
      Get.offNamed(MyRoutes.newPassword);
    }
  }
}
