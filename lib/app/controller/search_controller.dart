import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../model/search.dart';

class SearchResultController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ThemeController themeController = Get.put(ThemeController());

  dynamic argumentData = Get.arguments;
  String searchText = "";

  TextEditingController searchController = TextEditingController();
  final RxList<Search> _suggestions = <Search>[].obs;


  RxList<Search> filteredSuggestions = <Search>[].obs;
  RxList<Search> resultSuggestions = <Search>[].obs;
  bool isSuggestionClick = false;

  void getSearchResult(String value) {
    isSuggestionClick = true;
    filteredSuggestions.clear();
    resultSuggestions.clear();
    resultSuggestions.addAll(_getFilteredSuggestions(value));
  }

  void onSearchTextChanged(String value) {
    filteredSuggestions.assignAll(_getFilteredSuggestions(value));
    isSuggestionClick = false;
  }

  List<Search> _getFilteredSuggestions(String query) {
    return _suggestions
        .where((suggestion) => suggestion.name
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  void clearSuggestions() {
    filteredSuggestions.clear();
  }

  @override
  void onInit() {
    // Initialize search suggestions when the controller is created
    super.onInit();
    getSearchList();

    searchText = argumentData[0]['search_text'];
    searchController.text = searchText;
    filteredSuggestions.addAll(_suggestions);

    if (searchController.text.isNotEmpty) {
      onSearchTextChanged(searchText);
    }
    // print(searchText);
  }

  Future<List<Search>> getSearchList() async {
    String jsonData =
        await rootBundle.loadString("assets/data/search_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['searches'];
    for (int i = 0; i < jsonArray.length; i++) {
      _suggestions.add(Search.fromJson(jsonArray[i]));
    }
    return _suggestions;
  }
}
