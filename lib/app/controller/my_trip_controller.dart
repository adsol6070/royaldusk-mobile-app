import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../controller/theme_controller.dart';
import '../model/category.dart';
import '../model/hotels.dart';
import '../controller/auth_controller.dart';
import '../model/ticket.dart';
import '../model/booking.dart';

class MyTripController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  // Get AuthController instance to use its Dio client
  AuthController get authController => Get.find<AuthController>();

  RxList<Category> allCategories = <Category>[].obs;

  @override
  void onReady() {
    getCategory();
    fetchBookingsData();
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

  final RxList<Booking> myBookingsList = <Booking>[].obs;
  final RxBool isLoadingBookings = false.obs;
  final RxString bookingsError = ''.obs;
  final RxBool hasInitiallyLoaded =
      false.obs; // Track if initial load is complete

  // Fetch bookings from API using AuthController's Dio client
  Future<List<Booking>> fetchBookingsData() async {
    try {
      isLoadingBookings.value = true;
      bookingsError.value = '';

      // DON'T clear the list here - only clear after successful response
      // myBookingsList.clear(); // REMOVED THIS LINE

      // Check if user is authenticated
      if (!authController.isLoggedIn.value) {
        // For auth issues, clear list and mark as loaded
        myBookingsList.clear();
        hasInitiallyLoaded.value = true;
        return myBookingsList;
      }

      // Get user email from AuthController
      final String userEmail = authController.userEmail;

      if (userEmail.isEmpty) {
        // For missing email, clear list and mark as loaded
        myBookingsList.clear();
        hasInitiallyLoaded.value = true;
        return myBookingsList;
      }

      print('🔄 Fetching bookings from API for user: $userEmail');

      // Use AuthController's Dio client which has authentication headers and interceptors
      final dio.Dio dioClient = authController.dioClient;

      // Prepare POST request data with user email
      final requestData = {
        'email': userEmail,
      };

      // Make POST API call to get bookings with user email
      final response = await dioClient.post(
        '/booking-service/api/booking/userbooking',
        data: requestData,
      );

      print('📊 API Response Status: ${response.statusCode}');
      print('📦 API Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        // Parse the response using your BookingResponse model
        final BookingResponse bookingResponse =
            BookingResponse.fromJson(responseData);

        if (bookingResponse.success) {
          // Only NOW clear and update the list
          myBookingsList.clear();
          myBookingsList.addAll(bookingResponse.data);
          hasInitiallyLoaded.value = true;
          print(
              '✅ Successfully loaded ${bookingResponse.data.length} bookings for $userEmail');
        } else {
          // API says unsuccessful but this isn't an error - just no bookings
          myBookingsList.clear();
          hasInitiallyLoaded.value = true;
          print(
              '⚠️ API returned unsuccessful response: ${bookingResponse.message}');
        }
      } else {
        // Invalid response - treat as no bookings, not an error
        myBookingsList.clear();
        hasInitiallyLoaded.value = true;
        print('⚠️ Invalid response received from API');
      }

      return myBookingsList;
    } on dio.DioException catch (e) {
      String errorMessage = _parseBookingApiError(e);
      print('❌ Dio Exception while fetching bookings: $errorMessage');

      // Handle different types of errors appropriately
      if (e.response?.statusCode == 404) {
        // 404 means no bookings found - this is NOT an error state
        myBookingsList.clear();
        hasInitiallyLoaded.value = true;
        bookingsError.value = ''; // Clear any previous errors
      } else if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 403) {
        // Auth issues - clear bookings but don't show error
        myBookingsList.clear();
        hasInitiallyLoaded.value = true;
        bookingsError.value = ''; // Clear any previous errors
      } else {
        // Network/server errors - these are actual errors
        bookingsError.value = errorMessage;
        hasInitiallyLoaded.value = true;
        // Don't clear existing bookings for network errors if we have some
        if (myBookingsList.isEmpty) {
          // Only throw exception if we don't have any existing data AND it's a real error
          throw Exception(errorMessage);
        }
      }

      return myBookingsList;
    } catch (e) {
      String errorMessage = 'Error fetching bookings: ${e.toString()}';
      bookingsError.value = errorMessage;
      hasInitiallyLoaded.value = true;
      print('❌ Unexpected error while fetching bookings: $e');

      // Only throw if we don't have existing data
      if (myBookingsList.isEmpty) {
        throw Exception(errorMessage);
      }

      return myBookingsList;
    } finally {
      isLoadingBookings.value = false;
    }
  }

  // Parse API errors specific to booking requests
  String _parseBookingApiError(dio.DioException e) {
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case dio.DioExceptionType.connectionError:
        return 'Network error. Please check your internet connection.';
      case dio.DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 401:
            return 'Authentication failed. Please login again.';
          case 403:
            return 'Access denied. You don\'t have permission to view bookings.';
          case 404:
            return 'No bookings found for this user.';
          case 422:
            return 'Invalid request data. Please try again.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            // Try to extract error message from response
            if (e.response?.data != null) {
              final errorData = e.response!.data;
              if (errorData is Map<String, dynamic>) {
                return errorData['message'] ??
                    errorData['error'] ??
                    'Failed to load bookings';
              }
            }
            return 'Failed to load bookings. Please try again.';
        }
      default:
        return 'An unexpected error occurred while loading bookings';
    }
  }

  // Refresh bookings data
  Future<void> refreshBookings() async {
    await fetchBookingsData();
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
