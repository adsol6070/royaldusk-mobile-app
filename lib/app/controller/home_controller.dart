import 'dart:convert';

import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    getAllTopPackages();
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
    allPackages.clear();
    try {
      final response = await http.get(
        Uri.parse('https://api.royaldusk.com/package-service/api/package'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonArray = decoded['data'];
        for (var item in jsonArray) {
          allPackages.add(PopularPackage.fromJson(item));
        }
      } else {
        print("Failed to load all packages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading all packages: $e");
    }
    return allPackages;
  }

  Future<List<PopularPackage>> getAllPopularPackages() async {
    allPopularPackages.clear();
    try {
      final response = await http.get(
        Uri.parse('https://api.royaldusk.com/package-service/api/package'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonArray = decoded['data'];
        for (var item in jsonArray) {
          final pkg = PopularPackage.fromJson(item);
          // if (pkg.tag.toLowerCase() == 'Popular') {
          allPopularPackages.add(pkg);
          // }
        }
      } else {
        print("Failed to load popular packages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading popular packages: $e");
    }
    return allPopularPackages;
  }

  Future<List<PopularPackage>> getAllTopPackages() async {
    topPackages.clear();
    try {
      final response = await http.get(
        Uri.parse('https://api.royaldusk.com/package-service/api/package'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonArray = decoded['data'];
        for (var item in jsonArray) {
          final pkg = PopularPackage.fromJson(item);
          // if (pkg.tag.toLowerCase() == 'Top') {
          topPackages.add(pkg);
          // }
        }
      } else {
        print("Failed to load top packages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading top packages: $e");
    }
    return topPackages;
  }

  TextEditingController searchController = TextEditingController();
}

/* {
      "id": 2,
      "name": "Flight",
      "image": "https://i.ibb.co/nrcndkS/Plane.png"
    },
    {
      "id": 3,
      "name": "Places",
      "image": "https://i.ibb.co/mHN7HFn/Places.png"
    },
    {
      "id": 4,
      "name": "Hotel",
      "image": "https://i.ibb.co/6rd0LW6/Hotel.png"
    } */
