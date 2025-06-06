import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:get/get.dart';


class WelcomeController extends GetxController {

  void goToSignInScreen() {
    Get.toNamed(MyRoutes.signIn);
  }
}
