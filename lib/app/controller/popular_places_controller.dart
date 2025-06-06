import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../model/places.dart';


class PopularPlacesController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxString selectedOption = '1'.obs;

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }

  final RxList<Places> myData = <Places>[].obs;

  Future<List<Places>> fetchData() async {
    myData.clear();
    await Future.delayed(const Duration(seconds: 2));
    String jsonData = await rootBundle.loadString("assets/data/popular_places.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['places'];
    for (int i = 0; i < jsonArray.length; i++) {
      myData.add(Places.fromJson(jsonArray[i]));
    }
    return myData;
  }
}
