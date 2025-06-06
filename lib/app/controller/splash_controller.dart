import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 3));
    initialization();
  }

  void initialization() async {
    goToWelcomeScreen();
  }

  void goToWelcomeScreen() {
    Get.toNamed(MyRoutes.welcome);
  }
}
