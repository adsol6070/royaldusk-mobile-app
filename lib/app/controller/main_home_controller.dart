
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class MainHomeController extends GetxController {

  final ThemeController themeController = Get.put(ThemeController());
  RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }



  @override
  void onInit() {
    // Perform any initialization logic for the home controller
    super.onInit();
  }
}