import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'auth_controller.dart';

enum PaymentMethod { card, wallet, bank }

enum PaymentProvider { stripe, paypal, razorpay }

enum PaymentStatus { idle, processing, success, failed, cancelled }

enum PaymentIntentStatus { idle, creating, created, failed }

class PaymentController extends GetxController {
  static PaymentController get to => Get.find();

  // Dependencies
  final AuthController _authController = AuthController.to;

  // Payment state management
  final RxBool isProcessingPayment = false.obs;
  final RxBool isCreatingPaymentIntent = false.obs;
  final RxString lastPaymentError = ''.obs;
  final RxString lastCreatedIntentId = ''.obs;
  final RxString clientSecret = ''.obs;

  // Payment status tracking
  final Rx<PaymentStatus> paymentStatus = PaymentStatus.idle.obs;
  final Rx<PaymentIntentStatus> intentStatus = PaymentIntentStatus.idle.obs;

  // Payment history and tracking
  final RxList<Map<String, dynamic>> paymentHistory =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoadingPaymentHistory = false.obs;

  // Form validation state
  final RxBool isPaymentFormValid = false.obs;
  final RxMap<String, String?> paymentFormErrors = <String, String?>{}.obs;

  // Payment configuration
  final RxMap<String, dynamic> paymentConfig = <String, dynamic>{}.obs;

  // Stripe-specific properties
  PaymentIntent? _currentPaymentIntent;
  String? _currentBookingId;

  // Theme controller access (assuming you have one)
  dynamic get themeController =>
      Get.find(); // Adjust based on your theme controller

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    // Clear any previous state
    _resetPaymentState();

    // Listen to auth state changes
    ever(_authController.isLoggedIn, (bool isLoggedIn) {
      if (!isLoggedIn) {
        _resetPaymentState();
      }
    });

    // Load payment configuration
    _loadPaymentConfiguration();
  }

  /// Reset all payment-related state
  void _resetPaymentState() {
    isProcessingPayment.value = false;
    isCreatingPaymentIntent.value = false;
    lastPaymentError.value = '';
    lastCreatedIntentId.value = '';
    clientSecret.value = '';
    paymentStatus.value = PaymentStatus.idle;
    intentStatus.value = PaymentIntentStatus.idle;
    paymentFormErrors.clear();
    isPaymentFormValid.value = false;
    _currentPaymentIntent = null;
    _currentBookingId = null;
  }

  /// Load payment configuration from API or local storage
  Future<void> _loadPaymentConfiguration() async {
    try {
      paymentConfig.assignAll({
        'supportedMethods': ['card', 'wallet'],
        'supportedProviders': ['stripe'],
        'defaultCurrency': 'usd',
        'minAmount': 1.0,
        'maxAmount': 50000.0,
      });
    } catch (e) {
      print('⚠️ Failed to load payment configuration: $e');
    }
  }

  /// Create payment intent with your backend API
  Future<PaymentIntent?> createPaymentIntent({
    required String bookingId,
    required double amount,
    String currency = 'usd',
    PaymentProvider provider = PaymentProvider.stripe,
    PaymentMethod method = PaymentMethod.card,
    Map<String, dynamic>? metadata,
  }) async {
    // Pre-flight validations
    final validationResult = _validatePaymentIntentData(
      bookingId: bookingId,
      amount: amount,
      currency: currency,
    );

    if (!validationResult['isValid']) {
      lastPaymentError.value = validationResult['error'] ?? 'Validation failed';
      intentStatus.value = PaymentIntentStatus.failed;
      throw Exception(lastPaymentError.value);
    }

    // Check authentication
    if (!_authController.isValidSession) {
      lastPaymentError.value = 'Please log in to process payment';
      intentStatus.value = PaymentIntentStatus.failed;
      throw Exception(lastPaymentError.value);
    }

    isCreatingPaymentIntent.value = true;
    intentStatus.value = PaymentIntentStatus.creating;
    lastPaymentError.value = '';

    try {
      // Convert amount to cents (Stripe expects amount in smallest currency unit)
      final amountInCents = _convertToSmallestUnit(amount, currency);

      // Prepare payment intent payload for your backend
      final intentPayload = {
        'bookingId': bookingId.trim(),
        'amount': amountInCents,
        'currency': currency.toLowerCase(),
        'provider': _getProviderString(provider),
        'method': _getMethodString(method),
      };

      // Add metadata if provided
      // if (metadata != null && metadata.isNotEmpty) {
      //   intentPayload['metadata'] = metadata;
      // }

      print(
          '📤 Creating payment intent with payload: ${intentPayload.toString()}');

      // Make API call to your backend
      final response = await _authController.dioClient.post(
        'https://api.royaldusk.com/payment-service/payment/create-intent',
        data: intentPayload,
      );

      // Handle successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract client secret from your backend response
        String? extractedClientSecret;

        // Try different possible response structures
        if (responseData['client_secret'] != null) {
          extractedClientSecret = responseData['client_secret'];
        } else if (responseData['clientSecret'] != null) {
          extractedClientSecret = responseData['clientSecret'];
        } else if (responseData['data'] != null &&
            responseData['data']['client_secret'] != null) {
          extractedClientSecret = responseData['data']['client_secret'];
        } else if (responseData['data'] != null &&
            responseData['data']['clientSecret'] != null) {
          extractedClientSecret = responseData['data']['clientSecret'];
        }

        if (extractedClientSecret == null || extractedClientSecret.isEmpty) {
          throw Exception('Client secret not found in response');
        }

        // Store the client secret
        clientSecret.value = extractedClientSecret;
        _currentBookingId = bookingId;

        // Retrieve the PaymentIntent using Stripe SDK
        _currentPaymentIntent = await Stripe.instance.retrievePaymentIntent(
          extractedClientSecret,
        );

        if (_currentPaymentIntent != null) {
          lastCreatedIntentId.value = _currentPaymentIntent!.id;
          intentStatus.value = PaymentIntentStatus.created;

          print(
              '✅ Payment intent created successfully: ${lastCreatedIntentId.value}');

          return _currentPaymentIntent;
        } else {
          throw Exception('Failed to retrieve PaymentIntent from Stripe');
        }
      } else {
        throw Exception('Backend API error: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      print('❌ Dio Exception during payment intent creation');
      print('📊 Status code: ${e.response?.statusCode}');
      print('📦 Error response: ${e.response?.data}');

      final errorMessage = _parsePaymentError(e);
      lastPaymentError.value = errorMessage;
      intentStatus.value = PaymentIntentStatus.failed;
      throw Exception(errorMessage);
    } on StripeException catch (e) {
      print('❌ Stripe Exception: ${e.error.localizedMessage}');
      lastPaymentError.value =
          e.error.localizedMessage ?? 'Stripe error occurred';
      intentStatus.value = PaymentIntentStatus.failed;
      throw Exception(lastPaymentError.value);
    } catch (e) {
      print('❌ Unexpected error during payment intent creation: $e');
      lastPaymentError.value =
          'An unexpected error occurred while setting up payment';
      intentStatus.value = PaymentIntentStatus.failed;
      throw Exception(lastPaymentError.value);
    } finally {
      isCreatingPaymentIntent.value = false;
    }
  }

  /// Process payment using Stripe SDK
  Future<PaymentIntent?> confirmPaymentWithCard({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
    BillingDetails? billingDetails,
  }) async {
    if (_currentPaymentIntent == null || clientSecret.value.isEmpty) {
      throw Exception(
          'No payment intent found. Please create payment intent first.');
    }

    isProcessingPayment.value = true;
    paymentStatus.value = PaymentStatus.processing;
    lastPaymentError.value = '';

    try {
      // Parse expiry date (MM/YY format)
      final expiryParts = expiryDate.split('/');
      if (expiryParts.length != 2) {
        throw Exception('Invalid expiry date format');
      }

      final expMonth = int.tryParse(expiryParts[0]);
      final expYear = int.tryParse('20${expiryParts[1]}');

      if (expMonth == null ||
          expYear == null ||
          expMonth < 1 ||
          expMonth > 12) {
        throw Exception('Invalid expiry date');
      }

      // Create payment method with card details
      await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails ??
                BillingDetails(
                  name: cardHolderName,
                  email: _authController.userEmail,
                ),
          ),
        ),
      );

      // Confirm payment with the created payment method
      final confirmedPaymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret.value,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails ??
                BillingDetails(
                  name: cardHolderName,
                  email: _authController.userEmail,
                ),
          ),
        ),
      );

      // Check payment status
      if (confirmedPaymentIntent.status == PaymentIntentsStatus.Succeeded) {
        paymentStatus.value = PaymentStatus.success;

        // Refresh payment history
        _refreshPaymentHistory();

        print('✅ Payment successful: ${confirmedPaymentIntent.id}');
        return confirmedPaymentIntent;
      } else if (confirmedPaymentIntent.status ==
          PaymentIntentsStatus.RequiresAction) {
        // Handle 3D Secure or other authentication requirements
        throw Exception('Payment requires additional authentication');
      } else {
        throw Exception(
            'Payment failed with status: ${confirmedPaymentIntent.status}');
      }
    } on StripeException catch (e) {
      print('❌ Stripe Exception during payment: ${e.error.localizedMessage}');
      lastPaymentError.value = e.error.localizedMessage ?? 'Payment failed';
      paymentStatus.value = PaymentStatus.failed;
      throw Exception(lastPaymentError.value);
    } catch (e) {
      print('❌ Error during payment confirmation: $e');
      lastPaymentError.value = e.toString();
      paymentStatus.value = PaymentStatus.failed;
      throw Exception(lastPaymentError.value);
    } finally {
      isProcessingPayment.value = false;
    }
  }

  /// Present payment sheet (alternative to manual card entry)
  Future<PaymentIntent?> presentPaymentSheet() async {
    if (_currentPaymentIntent == null || clientSecret.value.isEmpty) {
      throw Exception(
          'No payment intent found. Please create payment intent first.');
    }

    isProcessingPayment.value = true;
    paymentStatus.value = PaymentStatus.processing;
    lastPaymentError.value = '';

    try {
      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret.value,
          merchantDisplayName: 'Royal Dusk',
          customerEphemeralKeySecret: null, // Add if you have customer keys
          customerId: _authController.userId,
          style: ThemeMode.system,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // If we reach here, payment was successful
      paymentStatus.value = PaymentStatus.success;

      // Refresh payment history
      _refreshPaymentHistory();

      print('✅ Payment sheet payment successful');
      return _currentPaymentIntent;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        paymentStatus.value = PaymentStatus.cancelled;
        lastPaymentError.value = 'Payment was cancelled';
      } else {
        paymentStatus.value = PaymentStatus.failed;
        lastPaymentError.value = e.error.localizedMessage ?? 'Payment failed';
      }
      print('❌ Stripe Exception in payment sheet: ${e.error.localizedMessage}');
      throw Exception(lastPaymentError.value);
    } catch (e) {
      paymentStatus.value = PaymentStatus.failed;
      lastPaymentError.value = 'Payment failed';
      print('❌ Error presenting payment sheet: $e');
      throw Exception(lastPaymentError.value);
    } finally {
      isProcessingPayment.value = false;
    }
  }

  /// Convert amount to smallest currency unit
  int _convertToSmallestUnit(double amount, String currency) {
    // Most currencies use 2 decimal places (cents)
    // Some currencies like JPY, KRW use 0 decimal places
    final zeroDecimalCurrencies = [
      'JPY',
      'KRW',
      'CLP',
      'BIF',
      'DJF',
      'GNF',
      'ISK',
      'KMF',
      'XAF',
      'XOF',
      'XPF'
    ];

    if (zeroDecimalCurrencies.contains(currency.toUpperCase())) {
      return amount.round();
    }

    return (amount * 100).round();
  }

  /// Get provider string for API
  String _getProviderString(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.stripe:
        return 'Stripe';
      case PaymentProvider.paypal:
        return 'PayPal';
      case PaymentProvider.razorpay:
        return 'Razorpay';
    }
  }

  /// Get method string for API
  String _getMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.bank:
        return 'Bank';
    }
  }

  /// Validate payment intent data before API call
  Map<String, dynamic> _validatePaymentIntentData({
    required String bookingId,
    required double amount,
    required String currency,
  }) {
    print('🔍 VALIDATION - Input bookingId: "$bookingId"');
    print('🔍 VALIDATION - Input amount: $amount');
    print('🔍 VALIDATION - Input currency: "$currency"');
    print(
        '🔍 VALIDATION - bookingId.trim().isEmpty: ${bookingId.trim().isEmpty}');
    print(
        '🔍 VALIDATION - _authController.userId: "${_authController.userId}"');
    print(
        '🔍 VALIDATION - _authController.userId.isEmpty: ${_authController.userId.isEmpty}');

    final Map<String, String> errors = {};

    // Booking ID validation
    if (bookingId.trim().isEmpty) {
      print('❌ VALIDATION - Booking ID is empty after trim');
      errors['bookingId'] = 'Booking ID is required';
    } else {
      print('✅ VALIDATION - Booking ID is valid');
    }

    // Amount validation
    if (amount <= 0) {
      print('❌ VALIDATION - Amount is <= 0');
      errors['amount'] = 'Amount must be greater than zero';
    } else {
      final minAmount = paymentConfig['minAmount'] ?? 1.0;
      final maxAmount = paymentConfig['maxAmount'] ?? 50000.0;
      print('🔍 VALIDATION - minAmount: $minAmount, maxAmount: $maxAmount');

      if (amount < minAmount) {
        print('❌ VALIDATION - Amount below minimum');
        errors['amount'] =
            'Amount must be at least \$${minAmount.toStringAsFixed(2)}';
      } else if (amount > maxAmount) {
        print('❌ VALIDATION - Amount above maximum');
        errors['amount'] =
            'Amount cannot exceed \$${maxAmount.toStringAsFixed(2)}';
      } else {
        print('✅ VALIDATION - Amount is valid');
      }
    }

    // Currency validation
    if (currency.trim().isEmpty) {
      print('❌ VALIDATION - Currency is empty');
      errors['currency'] = 'Currency is required';
    } else if (currency.length != 3) {
      print('❌ VALIDATION - Currency length != 3, length: ${currency.length}');
      errors['currency'] = 'Invalid currency code';
    } else {
      print('✅ VALIDATION - Currency is valid');
    }

    // Auth validation
    if (_authController.userId.isEmpty) {
      print('❌ VALIDATION - User ID is empty');
      errors['auth'] = 'User ID not found. Please log in again';
    } else {
      print('✅ VALIDATION - User ID is valid');
    }

    print('🔍 VALIDATION - Final errors: $errors');
    print('🔍 VALIDATION - Validation result: ${errors.isEmpty}');

    // Update form errors for UI
    paymentFormErrors.assignAll(errors);
    isPaymentFormValid.value = errors.isEmpty;

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'error': errors.isNotEmpty ? errors.values.first : null,
    };
  }

  /// Parse payment-specific errors from API response
  String _parsePaymentError(dio.DioException e) {
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
        return 'Invalid payment data. Please check your information and try again.';
      case 401:
        return 'Authentication expired. Please log in again.';
      case 403:
        return 'You do not have permission to process payments.';
      case 404:
        return 'Booking not found. Please verify the booking details.';
      case 409:
        return 'Payment already processed for this booking.';
      case 422:
        return 'Invalid payment information. Please review and correct your details.';
      case 429:
        return 'Too many payment attempts. Please wait a moment before trying again.';
      case 500:
        return 'Payment service error. Please try again later.';
      case 503:
        return 'Payment service is temporarily unavailable. Please try again later.';
      default:
        return 'Failed to process payment. Please try again.';
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

  /// Fetch user's payment history
  Future<void> fetchPaymentHistory() async {
    if (!_authController.isValidSession) {
      return;
    }

    isLoadingPaymentHistory.value = true;

    try {
      final response = await _authController.dioClient.get(
        'https://api.royaldusk.com/payment-service/payment/history/${_authController.userId}',
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract payments array from response
        List<dynamic> paymentsData = [];
        if (responseData['data'] != null) {
          if (responseData['data']['payments'] != null) {
            paymentsData = responseData['data']['payments'] as List;
          } else if (responseData['data'] is List) {
            paymentsData = responseData['data'] as List;
          }
        } else if (responseData['payments'] != null) {
          paymentsData = responseData['payments'] as List;
        }

        // Convert to List<Map<String, dynamic>>
        paymentHistory.assignAll(
          paymentsData
              .map((payment) => payment as Map<String, dynamic>)
              .toList(),
        );

        print('✅ Fetched ${paymentHistory.length} payments');
      }
    } catch (e) {
      print('❌ Error fetching payment history: $e');
      // Don't throw error for payment history fetch failure
    } finally {
      isLoadingPaymentHistory.value = false;
    }
  }

  /// Refresh payment history (silent fetch)
  void _refreshPaymentHistory() {
    fetchPaymentHistory();
  }

  /// Validate card information
  bool validateCardDetails({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
  }) {
    final Map<String, String> errors = {};

    // Card number validation
    final cleanCardNumber = cardNumber.replaceAll(' ', '');
    if (cleanCardNumber.isEmpty) {
      errors['cardNumber'] = 'Card number is required';
    } else if (cleanCardNumber.length < 13 || cleanCardNumber.length > 19) {
      errors['cardNumber'] = 'Invalid card number length';
    } else if (!_isValidCardNumber(cleanCardNumber)) {
      errors['cardNumber'] = 'Invalid card number';
    }

    // Expiry date validation
    if (expiryDate.isEmpty) {
      errors['expiryDate'] = 'Expiry date is required';
    } else if (!_isValidExpiryDate(expiryDate)) {
      errors['expiryDate'] = 'Invalid or expired date';
    }

    // CVV validation
    if (cvv.isEmpty) {
      errors['cvv'] = 'CVV is required';
    } else if (cvv.length < 3 || cvv.length > 4) {
      errors['cvv'] = 'Invalid CVV';
    }

    // Cardholder name validation
    if (cardHolderName.trim().isEmpty) {
      errors['cardHolderName'] = 'Cardholder name is required';
    }

    paymentFormErrors.assignAll(errors);
    isPaymentFormValid.value = errors.isEmpty;

    return errors.isEmpty;
  }

  /// Validate card number using Luhn algorithm
  bool _isValidCardNumber(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.tryParse(cardNumber[i]) ?? 0;

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }

  /// Validate expiry date
  bool _isValidExpiryDate(String expiryDate) {
    final parts = expiryDate.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse('20${parts[1]}');

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiry = DateTime(year, month);
    final currentMonth = DateTime(now.year, now.month);

    return expiry.isAfter(currentMonth) ||
        expiry.isAtSameMomentAs(currentMonth);
  }

  /// Clear form errors
  void clearPaymentErrors() {
    paymentFormErrors.clear();
    lastPaymentError.value = '';
    isPaymentFormValid.value = false;
    paymentStatus.value = PaymentStatus.idle;
    intentStatus.value = PaymentIntentStatus.idle;
  }

  /// Get error for specific field
  String? getFieldError(String fieldName) {
    return paymentFormErrors[fieldName];
  }

  /// Check if field has error
  bool hasFieldError(String fieldName) {
    return paymentFormErrors.containsKey(fieldName) &&
        paymentFormErrors[fieldName] != null;
  }

  /// Check if payment can be processed
  bool get canProcessPayment =>
      _authController.isValidSession &&
      !isLoading &&
      paymentStatus.value != PaymentStatus.processing;

  /// Check if payment intent can be created
  bool get canCreateIntent =>
      _authController.isValidSession &&
      !isCreatingPaymentIntent.value &&
      intentStatus.value != PaymentIntentStatus.creating;

  // Convenience getters
  bool get isLoading =>
      isProcessingPayment.value ||
      isCreatingPaymentIntent.value ||
      isLoadingPaymentHistory.value;
  bool get hasPaymentHistory => paymentHistory.isNotEmpty;
  bool get hasError => lastPaymentError.isNotEmpty;
  String get errorMessage => lastPaymentError.value;
  bool get isPaymentInProgress =>
      paymentStatus.value == PaymentStatus.processing;
  bool get isPaymentSuccessful => paymentStatus.value == PaymentStatus.success;
  bool get isPaymentFailed => paymentStatus.value == PaymentStatus.failed;
  bool get hasPaymentIntent =>
      lastCreatedIntentId.isNotEmpty && clientSecret.isNotEmpty;
  PaymentIntent? get currentPaymentIntent => _currentPaymentIntent;

  @override
  void onClose() {
    _resetPaymentState();
    super.onClose();
  }
}
