import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../model/hotels.dart';

class HotelListController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxString selectedOption = '1'.obs;

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }

  final RxList<Hotel> myData = <Hotel>[].obs;

  Future<List<Hotel>> fetchData() async {
    myData.clear();
    await Future.delayed(const Duration(seconds: 2));
    String jsonData =
        await rootBundle.loadString("assets/data/hotel_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['hotels'];
    for (int i = 0; i < jsonArray.length; i++) {
      myData.add(Hotel.fromJson(jsonArray[i]));
    }
    return myData;
  }
}
