import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

    try {
      final response = await http.get(
        Uri.parse('https://api.royaldusk.com/package-service/api/package'),
      );

      print('Popular Places Response: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<dynamic> jsonArray =
            decoded['data']; // or decoded directly if raw list
        for (var item in jsonArray) {
          myData.add(Places.fromJson(item));
        }

        print('Popular Places Loaded: ${myData.length}');
        return myData;
      } else {
        throw Exception('Failed to load popular places');
      }
    } catch (e) {
      print('Error fetching places: $e');
      return [];
    }
  }
}
