import 'dart:convert';


import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../model/ticket.dart';



class SelectFlightController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final RxList<Ticket> myData = <Ticket>[].obs;

  Future<List<Ticket>> fetchData() async {
    myData.clear();
    await Future.delayed(const Duration(seconds: 2));
    String jsonData = await rootBundle.loadString("assets/data/flight_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['flights_list'];
    for (int i = 0; i < jsonArray.length; i++) {
      myData.add(Ticket.fromJson(jsonArray[i]));
    }
    return myData;
  }


}
