import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../model/category.dart';
import '../model/hotels.dart';
import '../model/popular_packages.dart';
import '../model/ticket.dart';



class MyTripController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxList<Category> allCategories = <Category>[].obs;

  @override
  void onReady() {
    getCategory();
    super.onReady();
  }

  Future<List<Category>> getCategory() async {
    String jsonData = await rootBundle.loadString("assets/data/trip_cat.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['category'];
    for (int i = 0; i < jsonArray.length; i++) {
      allCategories.add(Category.fromJson(jsonArray[i]));
    }
    return allCategories;
  }

  final RxList<PopularPackage> myTripList = <PopularPackage>[].obs;

  Future<List<PopularPackage>> fetchData() async {
    myTripList.clear();
    await Future.delayed(const Duration(seconds: 1));
    String jsonData = await rootBundle.loadString("assets/data/my_trips.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['Packages'];
    for (int i = 0; i < jsonArray.length; i++) {
      myTripList.add(PopularPackage.fromJson(jsonArray[i]));
    }
    return myTripList;
  }

  final RxList<Ticket> myFlightList = <Ticket>[].obs;

  Future<List<Ticket>> fetchFlightData() async {
    myFlightList.clear();
    await Future.delayed(const Duration(seconds: 1));
    String jsonData =
        await rootBundle.loadString("assets/data/flight_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['flights_list'];
    for (int i = 0; i < jsonArray.length; i++) {
      myFlightList.add(Ticket.fromJson(jsonArray[i]));
    }
    return myFlightList;
  }

  final RxList<Hotel> myHotelList = <Hotel>[].obs;

  Future<List<Hotel>> fetchHotelData() async {
    myHotelList.clear();
    await Future.delayed(const Duration(seconds: 1));
    String jsonData =
        await rootBundle.loadString("assets/data/hotel_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['hotels'];
    for (int i = 0; i < jsonArray.length; i++) {
      myHotelList.add(Hotel.fromJson(jsonArray[i]));
    }
    return myHotelList;
  }

  int selectedIndex = 0;

  void toggleSelection(int index) {
    selectedIndex = index;
    // allCategories[index].isSelected = !allCategories[index].isSelected;
    update();
  }
}
