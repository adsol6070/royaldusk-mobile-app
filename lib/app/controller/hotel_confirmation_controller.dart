import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class HotelConfirmationController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxInt quantity = 1.obs;

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
