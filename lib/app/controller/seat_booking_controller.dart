import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import '../model/seat.dart';

class SeatBookingController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  final RxList<Seat> myData = <Seat>[].obs;

  void toggleSeatSelection(int index) {
    myData[index].isSelected.value = !myData[index].isSelected.value;
  }

  List<String> getSelectedSeats() {
    List<String> selectedSeatNumbers = [];
    for (int i = 0; i < myData.length; i++) {
      if (myData[i].isSelected.value) {
        selectedSeatNumbers.add(myData[i].seatNumber.toString());
      }
    }
    return selectedSeatNumbers;
  }

  Future<List<Seat>> fetchData() async {
    myData.clear();
    // await Future.delayed(const Duration(seconds: 1));
    String jsonData = await rootBundle.loadString("assets/data/seat_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['seat_list'];
    for (int i = 0; i < jsonArray.length; i++) {
      myData.add(Seat.fromJson(jsonArray[i]));
    }
    return myData;
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
