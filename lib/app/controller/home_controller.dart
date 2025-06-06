import 'dart:convert';

import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import '../model/category.dart';
import '../model/popular_packages.dart';



class HomeController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxList<Category> allCategories = <Category>[].obs;
  final RxList<PopularPackage> allPackages = <PopularPackage>[].obs;
  final RxList<PopularPackage> allPopularPackages = <PopularPackage>[].obs;
  final RxList<PopularPackage> topPackages = <PopularPackage>[].obs;
  int popularPkgCurrentIndex = 0;


  @override
  void onReady() {
    getCategory();
    getAllPackages();
    getAllPopularPackages();
    // getAllTopPackages();
    super.onReady();
  }

  void goToPopularPackageScreen() {
    Get.toNamed(MyRoutes.popularPackageScreen);
  }

  void goToFlightScreen() {
    Get.toNamed(MyRoutes.flightScreen);
  }

  void goToPopularPlacesScreen() {
    Get.toNamed(MyRoutes.popularPlace);
  }

  void goToPopularHotelScreen() {
    Get.toNamed(MyRoutes.popularHotel);
  }
  void goToSearchScreen() {
    Get.toNamed(MyRoutes.searchScreen, arguments: [
      {'search_text': searchController.text.toString()}
    ]);
  }

  @override
  void onClose() {}

  Future<List<Category>> getCategory() async {
    String jsonData = await rootBundle.loadString("assets/data/category.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['category'];
    for (int i = 0; i < jsonArray.length; i++) {
      allCategories.add(Category.fromJson(jsonArray[i]));
    }
    return allCategories;
  }

  Future<List<PopularPackage>> getAllPackages() async {
    String jsonData = await rootBundle.loadString("assets/data/packages.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['Packages'];
    for (int i = 0; i < jsonArray.length; i++) {
      allPackages.add(PopularPackage.fromJson(jsonArray[i]));
    }
    return allPackages;
  }

  Future<List<PopularPackage>> getAllPopularPackages() async {
    String jsonData =
        await rootBundle.loadString("assets/data/popular_packages.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['Packages'];
    for (int i = 0; i < jsonArray.length; i++) {
      allPopularPackages.add(PopularPackage.fromJson(jsonArray[i]));
    }
    return allPopularPackages;
  }

  Future<List<PopularPackage>> getAllTopPackages() async {
    topPackages.clear();
    String jsonData =
        await rootBundle.loadString("assets/data/top_packages.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['Packages'];
    for (int i = 0; i < jsonArray.length; i++) {
      topPackages.add(PopularPackage.fromJson(jsonArray[i]));
    }
    return topPackages;
  }

  TextEditingController searchController = TextEditingController();
}
