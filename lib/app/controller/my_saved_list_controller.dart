import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/theme_controller.dart';
import '../controller/popular_packages_controller.dart';

import '../model/category.dart';
import '../model/hotels.dart';
import '../model/popular_packages.dart';
import '../model/ticket.dart';
import '../model/places.dart';

class MySavedController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  
  // GetStorage instance
  final _storage = GetStorage();
  static const String _savedPackagesKey = 'saved_packages_full_data';
  
  RxList<Category> allCategories = <Category>[].obs;
  RxList<PopularPackage> savedPackages = <PopularPackage>[].obs;
  RxBool isLoadingSavedPackages = false.obs;

  @override
  void onReady() {
    getCategory();
    loadSavedPackages();
    super.onReady();
  }

  Future<List<Category>> getCategory() async {
    String jsonData = await rootBundle.loadString("assets/data/category.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['category'];
    for (int i = 0; i < jsonArray.length; i++) {
      allCategories.add(Category.fromJson(jsonArray[i]));
    }
    return allCategories;
  }

  // Load saved packages from GetStorage (complete package data)
  void loadSavedPackages() {
    try {
      isLoadingSavedPackages.value = true;
      final List<dynamic>? savedData = _storage.read(_savedPackagesKey);
      
      if (savedData != null && savedData.isNotEmpty) {
        savedPackages.clear();
        for (var packageData in savedData) {
          try {
            savedPackages.add(PopularPackage.fromJson(packageData as Map<String, dynamic>));
          } catch (e) {
            print('Error parsing saved package: $e');
          }
        }
        print('✅ Loaded ${savedPackages.length} saved packages from storage');
      } else {
        print('ℹ️ No saved packages found in storage');
        savedPackages.clear();
      }
    } catch (e) {
      print('❌ Error loading saved packages: $e');
      savedPackages.clear();
    } finally {
      isLoadingSavedPackages.value = false;
    }
  }

  // Save complete package data to GetStorage
  void _savePersistentData() {
    try {
      final List<Map<String, dynamic>> packagesJson = 
          savedPackages.map((package) => _packageToJson(package)).toList();
      
      _storage.write(_savedPackagesKey, packagesJson);
      print('✅ Saved ${savedPackages.length} complete packages to storage');
    } catch (e) {
      print('❌ Error saving packages to storage: $e');
    }
  }

  // Convert PopularPackage to JSON
  Map<String, dynamic> _packageToJson(PopularPackage package) {
    return {
      'id': package.id,
      'name': package.name,
      'slug': package.slug,
      'description': package.description,
      'importantInfo': package.importantInfo,
      'imageUrl': package.imageUrl,
      'price': package.price,
      'currency': package.currency,
      'review': package.review,
      'duration': package.duration,
      'availability': package.availability,
      'hotels': package.hotels,
      'tag': package.tag,
      'location': {
        'id': package.location.id,
        'name': package.location.name,
        'imageUrl': package.location.imageUrl,
        'createdAt': package.location.createdAt,
        'updatedAt': package.location.updatedAt,
      },
      'policy': {
        'id': package.policy.id,
        'bookingPolicy': package.policy.bookingPolicy,
        'cancellationPolicy': package.policy.cancellationPolicy,
        'paymentTerms': package.policy.paymentTerms,
        'visaDetail': package.policy.visaDetail,
      },
      'features': package.features.map((f) => {
        'id': f.id,
        'name': f.name,
      }).toList(),
      'itineraries': package.itineraries.map((i) => {
        'id': i.id,
        'title': i.title,
        'description': i.description,
      }).toList(),
      'inclusions': package.inclusions.map((inc) => {
        'id': inc.id,
        'name': inc.name,
      }).toList(),
      'exclusions': package.exclusions.map((exc) => {
        'id': exc.id,
        'name': exc.name,
      }).toList(),
    };
  }

  // Check if a package is saved
  bool isPackageSaved(String packageId) {
    return savedPackages.any((package) => package.id == packageId);
  }

  // Add package to saved list
  Future<bool> savePackage(PopularPackage package) async {
    try {
      // Check if already saved
      if (isPackageSaved(package.id)) {
        print('⚠️ Package ${package.name} is already saved');
        return false;
      }

      savedPackages.add(package);
      _savePersistentData();
      
      print('✅ Package ${package.name} saved successfully');
      Get.snackbar(
        'Saved!',
        '${package.name} added to your saved packages',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      return true;
    } catch (e) {
      print('❌ Error saving package: $e');
      Get.snackbar(
        'Error',
        'Failed to save package. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Remove package from saved list
  Future<bool> unsavePackage(String packageId) async {
    try {
      final int initialCount = savedPackages.length;
      savedPackages.removeWhere((package) => package.id == packageId);
      
      if (savedPackages.length < initialCount) {
        _savePersistentData();
        
        print('✅ Package unsaved successfully');
        Get.snackbar(
          'Removed!',
          'Package removed from saved list',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        return true;
      } else {
        print('⚠️ Package not found in saved list');
        return false;
      }
    } catch (e) {
      print('❌ Error unsaving package: $e');
      Get.snackbar(
        'Error',
        'Failed to remove package. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Toggle save status
  Future<bool> togglePackageSave(PopularPackage package) async {
    if (isPackageSaved(package.id)) {
      return await unsavePackage(package.id);
    } else {
      return await savePackage(package);
    }
  }

  // Clear all saved packages
  Future<void> clearAllSavedPackages() async {
    try {
      savedPackages.clear();
      _storage.remove(_savedPackagesKey);
      
      print('✅ All saved packages cleared');
      Get.snackbar(
        'Cleared!',
        'All saved packages have been removed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error clearing saved packages: $e');
    }
  }

  // Get saved packages (for compatibility with existing UI)
  List<PopularPackage> get myTripList => savedPackages;

  // For compatibility with existing UI, return Future
  Future<List<PopularPackage>> fetchData() async {
    // Reload saved packages from storage to ensure latest data
    loadSavedPackages();
    return savedPackages;
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
  
  final RxList<Places> myPlacesList = <Places>[].obs;

  Future<List<Places>> fetchPlacesData() async {
    myPlacesList.clear();
    await Future.delayed(const Duration(seconds: 1));
    String jsonData =
    await rootBundle.loadString("assets/data/popular_places.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['places'];
    for (int i = 0; i < jsonArray.length; i++) {
      myPlacesList.add(Places.fromJson(jsonArray[i]));
    }
    return myPlacesList;
  }

  int selectedIndex = 0;

  void toggleSelection(int index) {
    selectedIndex = index;
    // Refresh saved packages when switching to packages tab
    if (index == 0) {
      loadSavedPackages();
    }
    update();
  }

  // Get result count for display
  String getResultText() {
    switch (selectedIndex) {
      case 0:
        return "Result found (${savedPackages.length})";
      case 1:
        return "Result found (${myFlightList.length})";
      case 2:
        return "Result found (${myPlacesList.length})";
      case 3:
        return "Result found (${myHotelList.length})";
      default:
        return "Result found (0)";
    }
  }
}