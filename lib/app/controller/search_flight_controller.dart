import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

enum TripType { oneway, rountrip, multicity }

class SearchFlightController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ThemeController themeController = Get.put(ThemeController());

  Rx<TripType> selectedTrip = TripType.rountrip.obs;

  final TextEditingController fromController=TextEditingController(text: "New York, United America");
  final TextEditingController toController=TextEditingController(text: "East Evritania, Singapore");
  final TextEditingController departureController=TextEditingController(text: "07 June, 2023");
  final TextEditingController returnController=TextEditingController(text: "15 June, 2023");

  void setSelectedTrip(TripType tripType) {
    selectedTrip.value = tripType;
  }

  RxString selectedClass = ''.obs;
  void selectClass(String classValue) {
    selectedClass.value = classValue;
  }

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
