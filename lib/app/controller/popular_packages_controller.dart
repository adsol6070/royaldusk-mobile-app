import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../model/popular_packages.dart';



class PopularPackagesController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxString selectedOption = '1'.obs;

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }

  final RxList<PopularPackage> myData = <PopularPackage>[].obs;

  Future<List<PopularPackage>> fetchData() async {
    myData.clear();
    await Future.delayed(const Duration(seconds: 2));
    String jsonData = await rootBundle.loadString("assets/data/popular_packages.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['Packages'];
    for (int i = 0; i < jsonArray.length; i++) {
      myData.add(PopularPackage.fromJson(jsonArray[i]));
    }
    return myData;
  }
}
