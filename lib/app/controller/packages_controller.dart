import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';

import '../controller/theme_controller.dart';
import '../model/package.dart';
import '../enums/package_types.dart';

class PackagesController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  final PackageType packageType;

  PackagesController({required this.packageType});

  dio.Dio get _dioClient => AuthController.to.dioClient;

  RxString selectedOption = '1'.obs;
  final RxList<Package> allPackages = <Package>[].obs;
  final RxList<Package> _filteredPackages = <Package>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void setSelectedOption(String option) {
    selectedOption.value = option;
    _updateFilteredPackages();
  }

  // Make this getter reactive by returning the RxList
  RxList<Package> get filteredPackages => _filteredPackages;

  @override
  void onInit() {
    super.onInit();
    // Fetch data when controller is initialized
    fetchData();
  }

  Future<List<Package>> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    allPackages.clear();
    _filteredPackages.clear(); // Clear filtered packages too

    try {
      final response = await _dioClient.get('/package-service/api/package');

      if (response.statusCode == 200) {
        final responseData = response.data;

        List<dynamic> jsonArray;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('data')) {
            jsonArray = responseData['data'] as List<dynamic>;
          } else {
            jsonArray = responseData.values.first as List<dynamic>;
          }
        } else if (responseData is List<dynamic>) {
          jsonArray = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        for (var item in jsonArray) {
          try {
            final pkg = Package.fromJson(item as Map<String, dynamic>);
            allPackages.add(pkg);
          } catch (e) {
            print('⚠️ Error parsing package item: $e');
            print('📦 Item data: $item');
          }
        }

        _updateFilteredPackages();

        return _filteredPackages.toList();
      } else {
        throw Exception(
            "Failed to load packages (Status: ${response.statusCode})");
      }
    } on dio.DioException catch (e) {
      String error = _handleDioError(e);
      errorMessage.value = error;
      print("❌ Dio Error fetching packages: $error");
      throw Exception(error);
    } catch (e) {
      String error = "Unexpected error occurred: ${e.toString()}";
      errorMessage.value = error;
      print("❌ Unexpected error fetching packages: $e");
      throw Exception(error);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFilteredPackages() {
    List<Package> packages = [];

    switch (packageType) {
      case PackageType.all:
        packages = allPackages.toList();
        break;
      case PackageType.popular:
        packages = allPackages.toList();
        break;
      case PackageType.top:
        packages = allPackages.toList();
        break;
    }

    _filteredPackages.value = _sortPackages(packages);
  }

  List<Package> _sortPackages(List<Package> packages) {
    List<Package> sortedPackages = List.from(packages);

    switch (selectedOption.value) {
      case '1': // High Price
        sortedPackages.sort((a, b) {
          final priceA = a.price;
          final priceB = b.price;
          return priceB.compareTo(priceA);
        });
        break;
      case '2': // Low Price
        sortedPackages.sort((a, b) {
          final priceA = a.price;
          final priceB = b.price;
          return priceA.compareTo(priceB);
        });
        break;
      // case '3': // Trending Now
      //   sortedPackages.sort((a, b) {
      //     final trendingA = a.trendingScore ?? 0.0;
      //     final trendingB = b.trendingScore ?? 0.0;
      //     return trendingB.compareTo(trendingA);
      //   });
      //   print('📊 Sorted by trending score');
      //   break;
      default:
        sortedPackages.sort((a, b) {
          final nameA = a.name;
          final nameB = b.name;
          return nameA.compareTo(nameB);
        });
        break;
    }
    return sortedPackages;
  }

  String _handleDioError(dio.DioException e) {
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case dio.DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case dio.DioExceptionType.connectionError:
        return 'Network error. Please check your internet connection.';
      case dio.DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            return 'Bad request. Please try again.';
          case 401:
            return 'Authentication failed. Please login again.';
          case 403:
            return 'Access denied. You don\'t have permission to view packages.';
          case 404:
            return 'Packages not found. Please try again later.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Failed to load packages. Please try again.';
        }
      case dio.DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> refreshPackages() async {
    await fetchData();
  }

  void clearError() {
    errorMessage.value = '';
  }

  int get packagesCount {
    switch (packageType) {
      case PackageType.all:
        return allPackages.length;
      case PackageType.popular:
        return allPackages.length;
      case PackageType.top:
        return allPackages.length;
    }
  }

  bool get hasPackages => _filteredPackages.isNotEmpty;

  void goToAllPackageScreen() {
    Get.toNamed('/packages', arguments: PackageType.all);
  }

  void goToPopularPackageScreen() {
    Get.toNamed('/packages', arguments: PackageType.popular);
  }

  void goToTopPackageScreen() {
    Get.toNamed('/packages', arguments: PackageType.top);
  }
}
