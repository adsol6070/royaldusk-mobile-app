import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

    try {
      final response = await http.get(
        Uri.parse('https://api.royaldusk.com/package-service/api/package'),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}'); // Full raw response

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('Decoded JSON: $decoded');

        List<dynamic> jsonArray = decoded['data'];
        print('Parsed Data List Length: ${jsonArray.length}');

        for (var item in jsonArray) {
          final pkg = PopularPackage.fromJson(item);
          print('Parsed Package: ${pkg.name}');
          myData.add(pkg);
        }

        /// ✅ Log full myData contents
        print("Final myData length: ${myData.length}");
        for (int i = 0; i < myData.length; i++) {
          print("myData[$i] => ID: ${myData[i].id}, Name: ${myData[i].name}");
        }

        return myData;
      } else {
        throw Exception(
            "Failed to load packages (Status: ${response.statusCode})");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
