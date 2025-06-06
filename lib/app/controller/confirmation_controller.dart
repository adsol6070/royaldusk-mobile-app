import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class ConfirmationController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxInt quantity = 2.obs;

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
