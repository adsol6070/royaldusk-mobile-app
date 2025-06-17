import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controller/theme_controller.dart';
import '../model/all_packages.dart';

class AllPackagesController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxString selectedOption = '1'.obs;

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }

  final RxList<AllPackage> myAllPackagesData = <AllPackage>[].obs;

  Future<List<AllPackage>> fetchData() async {
    myAllPackagesData.clear();

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
          final pkg = AllPackage.fromJson(item);
          print('Parsed Package: ${pkg.name}');
          myAllPackagesData.add(pkg);
        }

        /// ✅ Log full myData contents
        print("Final myData length: ${myAllPackagesData.length}");
        for (int i = 0; i < myAllPackagesData.length; i++) {
          print("myData[$i] => ID: ${myAllPackagesData[i].id}, Name: ${myAllPackagesData[i].name}");
        }

        return myAllPackagesData;
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
