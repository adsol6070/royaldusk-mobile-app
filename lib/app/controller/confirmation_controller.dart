import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:royaldusk_mobile_app/app/model/package.dart';
import 'auth_controller.dart';

class ConfirmationController extends GetxController {
  static ConfirmationController get to => Get.find();

  // Dependencies
  final AuthController _authController = AuthController.to;

  // Booking state management
  final RxBool isCreatingBooking = false.obs;
  final RxBool isLoadingBookingHistory = false.obs;
  final RxString lastBookingError = ''.obs;
  final RxString lastCreatedBookingId = ''.obs;
  final RxList<Map<String, dynamic>> bookingHistory =
      <Map<String, dynamic>>[].obs;

  // Form validation state
  final RxBool isFormValid = false.obs;
  final RxMap<String, String?> formErrors = <String, String?>{}.obs;

  // Theme controller (assuming you have one)
  // Replace with your actual theme controller implementation
  dynamic get themeController =>
      Get.find(); // Adjust based on your theme controller

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    // Clear any previous state
    _resetBookingState();

    // Listen to auth state changes
    ever(_authController.isLoggedIn, (bool isLoggedIn) {
      if (!isLoggedIn) {
        _resetBookingState();
      }
    });
  }

  /// Reset all booking-related state
  void _resetBookingState() {
    isCreatingBooking.value = false;
    lastBookingError.value = '';
    lastCreatedBookingId.value = '';
    formErrors.clear();
    isFormValid.value = false;
  }

  /// Create booking with comprehensive validation and error handling
  Future<Map<String, dynamic>?> createBooking({
    required Package package,
    required DateTime startDate,
    required int travelers,
    required String phoneNumber,
    String? nationality,
    String? remarks,
    bool agreedToTerms = true,
  }) async {
    // Pre-flight validations
    final validationResult = _validateBookingData(
      package: package,
      startDate: startDate,
      travelers: travelers,
      phoneNumber: phoneNumber,
    );

    if (!validationResult['isValid']) {
      lastBookingError.value = validationResult['error'] ?? 'Validation failed';
      throw Exception(lastBookingError.value);
    }

    // Check authentication
    if (!_authController.isValidSession) {
      lastBookingError.value = 'Please log in to create a booking';
      throw Exception(lastBookingError.value);
    }

    isCreatingBooking.value = true;
    lastBookingError.value = '';

    try {
      // Prepare booking payload
      final bookingPayload = _buildBookingPayload(
        package: package,
        startDate: startDate,
        travelers: travelers,
        phoneNumber: phoneNumber,
        nationality: nationality,
        remarks: remarks,
        agreedToTerms: agreedToTerms,
      );

      print('📤 Creating booking with payload: ${bookingPayload.toString()}');

      // Make API call
      final response = await _authController.dioClient.post(
        '/booking-service/api/booking',
        data: bookingPayload,
      );

      // Handle successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract booking ID from response
        final bookingId = _extractBookingId(responseData);
        if (bookingId != null) {
          lastCreatedBookingId.value = bookingId;
        }

        print('✅ Booking created successfully: $bookingId');

        // Refresh booking history
        _refreshBookingHistory();

        return responseData;
      } else {
        throw Exception('Unexpected response status: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      print('❌ Dio Exception during booking creation');
      print('📊 Status code: ${e.response?.statusCode}');
      print('📦 Error response: ${e.response?.data}');

      final errorMessage = _parseBookingError(e);
      lastBookingError.value = errorMessage;
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Unexpected error during booking creation: $e');
      lastBookingError.value =
          'An unexpected error occurred while creating your booking';
      throw Exception(lastBookingError.value);
    } finally {
      isCreatingBooking.value = false;
    }
  }

  /// Build booking payload from provided data
  Map<String, dynamic> _buildBookingPayload({
    required Package package,
    required DateTime startDate,
    required int travelers,
    required String phoneNumber,
    String? nationality,
    String? remarks,
    bool agreedToTerms = true,
  }) {
    // Format start date to ISO string
    final formattedStartDate = startDate.toUtc().toIso8601String();

    return {
      'userId': _authController.userId,
      'guestName': _authController.displayName,
      'guestEmail': _authController.userEmail,
      'guestMobile': phoneNumber.trim(),
      'guestNationality': nationality?.trim() ?? 'Not specified',
      'remarks': remarks?.trim() ?? '',
      'agreedToTerms': agreedToTerms,
      'items': [
        {
          'packageId': package.id,
          'travelers': travelers,
          'startDate': formattedStartDate,
        }
      ],
    };
  }

  /// Validate booking data before API call
  Map<String, dynamic> _validateBookingData({
    required Package package,
    required DateTime startDate,
    required int travelers,
    required String phoneNumber,
  }) {
    final Map<String, String> errors = {};

    // Package validation
    if (package.id.isEmpty) {
      errors['package'] = 'Invalid package selected';
    }

    // Date validation
    final now = DateTime.now();
    final minDate = DateTime(now.year, now.month, now.day);
    if (startDate.isBefore(minDate)) {
      errors['startDate'] = 'Start date cannot be in the past';
    }

    // Travelers validation
    if (travelers < 1) {
      errors['travelers'] = 'At least 1 traveler is required';
    } else if (travelers > 10) {
      errors['travelers'] = 'Maximum 10 travelers allowed';
    }

    // Phone validation
    if (phoneNumber.trim().isEmpty) {
      errors['phone'] = 'Phone number is required';
    } else if (phoneNumber.trim().length < 10) {
      errors['phone'] = 'Please enter a valid phone number';
    }

    // Auth validation
    if (_authController.userId.isEmpty) {
      errors['auth'] = 'User ID not found. Please log in again';
    }

    if (_authController.userEmail.isEmpty) {
      errors['auth'] = 'User email not found. Please log in again';
    }

    if (_authController.displayName.isEmpty) {
      errors['auth'] = 'User name not found. Please update your profile';
    }

    // Update form errors for UI
    formErrors.assignAll(errors);
    isFormValid.value = errors.isEmpty;

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'error': errors.isNotEmpty ? errors.values.first : null,
    };
  }

  /// Parse booking-specific errors from API response
  String _parseBookingError(dio.DioException e) {
    if (e.response?.data != null) {
      final errorData = e.response!.data;

      if (errorData is Map<String, dynamic>) {
        // Handle structured error responses
        if (errorData['message'] != null) {
          return errorData['message'].toString();
        }
        if (errorData['error'] != null) {
          return errorData['error'].toString();
        }
        if (errorData['errors'] != null) {
          return _extractFirstValidationError(errorData['errors']);
        }
      }
    }

    // Handle HTTP status codes
    switch (e.response?.statusCode) {
      case 400:
        return 'Invalid booking data. Please check your information and try again.';
      case 401:
        return 'Authentication expired. Please log in again.';
      case 403:
        return 'You do not have permission to create bookings.';
      case 409:
        return 'Booking conflict detected. This package may no longer be available for the selected date.';
      case 422:
        return 'Invalid booking information. Please review and correct your details.';
      case 429:
        return 'Too many booking attempts. Please wait a moment before trying again.';
      case 500:
        return 'Server error occurred. Please try again later.';
      case 503:
        return 'Booking service is temporarily unavailable. Please try again later.';
      default:
        return 'Failed to create booking. Please try again.';
    }
  }

  /// Extract first validation error from errors object
  String _extractFirstValidationError(dynamic errors) {
    if (errors is Map<String, dynamic>) {
      for (final error in errors.values) {
        if (error is List && error.isNotEmpty) {
          return error.first.toString();
        } else if (error is String) {
          return error;
        }
      }
    } else if (errors is List && errors.isNotEmpty) {
      return errors.first.toString();
    }
    return 'Validation errors occurred';
  }

  /// Extract booking ID from response
  String? _extractBookingId(Map<String, dynamic> response) {
    // Try different possible locations for booking ID
    final possiblePaths = [
      'data.booking.id',
      'data.bookingId',
      'data.id',
      'booking.id',
      'bookingId',
      'id',
    ];

    for (final path in possiblePaths) {
      final value = _getNestedValue(response, path);
      if (value != null) {
        return value.toString();
      }
    }
    return null;
  }

  /// Get nested value from map using dot notation
  dynamic _getNestedValue(Map<String, dynamic> map, String path) {
    final keys = path.split('.');
    dynamic current = map;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  /// Fetch user's booking history
  Future<void> fetchBookingHistory() async {
    if (!_authController.isValidSession) {
      return;
    }

    isLoadingBookingHistory.value = true;

    try {
      final response = await _authController.dioClient.get(
        '/booking-service/api/booking/user/${_authController.userId}',
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract bookings array from response
        List<dynamic> bookingsData = [];
        if (responseData['data'] != null) {
          if (responseData['data']['bookings'] != null) {
            bookingsData = responseData['data']['bookings'] as List;
          } else if (responseData['data'] is List) {
            bookingsData = responseData['data'] as List;
          }
        } else if (responseData['bookings'] != null) {
          bookingsData = responseData['bookings'] as List;
        }

        // Convert to List<Map<String, dynamic>>
        bookingHistory.assignAll(
          bookingsData
              .map((booking) => booking as Map<String, dynamic>)
              .toList(),
        );

        print('✅ Fetched ${bookingHistory.length} bookings');
      }
    } catch (e) {
      print('❌ Error fetching booking history: $e');
      // Don't throw error for booking history fetch failure
    } finally {
      isLoadingBookingHistory.value = false;
    }
  }

  /// Refresh booking history (silent fetch)
  void _refreshBookingHistory() {
    fetchBookingHistory();
  }

  /// Get booking by ID
  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    if (!_authController.isValidSession || bookingId.isEmpty) {
      return null;
    }

    try {
      final response = await _authController.dioClient.get(
        '/booking-service/api/booking/$bookingId',
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print('❌ Error fetching booking $bookingId: $e');
    }
    return null;
  }

  /// Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    if (!_authController.isValidSession || bookingId.isEmpty) {
      return false;
    }

    try {
      final response = await _authController.dioClient.patch(
        '/booking-service/api/booking/$bookingId/cancel',
      );

      if (response.statusCode == 200) {
        // Refresh booking history after cancellation
        _refreshBookingHistory();
        return true;
      }
    } catch (e) {
      print('❌ Error cancelling booking $bookingId: $e');
    }
    return false;
  }

  /// Validate form input and update state
  void validateForm({
    Package? package,
    DateTime? startDate,
    int? travelers,
    String? phoneNumber,
  }) {
    if (package != null &&
        startDate != null &&
        travelers != null &&
        phoneNumber != null) {
      _validateBookingData(
        package: package,
        startDate: startDate,
        travelers: travelers,
        phoneNumber: phoneNumber,
      );
    }
  }

  /// Clear form errors
  void clearFormErrors() {
    formErrors.clear();
    lastBookingError.value = '';
    isFormValid.value = false;
  }

  /// Get error for specific field
  String? getFieldError(String fieldName) {
    return formErrors[fieldName];
  }

  /// Check if field has error
  bool hasFieldError(String fieldName) {
    return formErrors.containsKey(fieldName) && formErrors[fieldName] != null;
  }

  // Convenience getters
  bool get isLoading =>
      isCreatingBooking.value || isLoadingBookingHistory.value;
  bool get hasBookingHistory => bookingHistory.isNotEmpty;
  bool get hasError => lastBookingError.isNotEmpty;
  String get errorMessage => lastBookingError.value;
  bool get canCreateBooking => _authController.isValidSession && !isLoading;

  @override
  void onClose() {
    _resetBookingState();
    super.onClose();
  }
}
