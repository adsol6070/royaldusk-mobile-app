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

  // Form validation state
  final RxMap<String, String?> paymentFormErrors = <String, String?>{}.obs;

  // Payment configuration
  final RxMap<String, dynamic> paymentConfig = <String, dynamic>{}.obs;

  // Stripe-specific properties
  PaymentIntent? _currentPaymentIntent;

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
    _currentPaymentIntent = null;
  }

  /// Load payment configuration
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
    String? customerPhone,
    String? customerNationality,
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

      // 🎯 Enhanced payload with customer information for real customer creation
      final intentPayload = {
        'bookingId': bookingId.trim(),
        'amount': amountInCents,
        'currency': currency.toLowerCase(),
        'provider': _getProviderString(provider),
        'method': _getMethodString(method),

        // 🎯 Add customer information for backend customer creation
        'customerInfo': {
          'userId': _authController.userId,
          'name': _authController.displayName,
          'email': _authController.userEmail,
          'phone': customerPhone ?? _authController.phoneNumber,
          'nationality': customerNationality,
        },

        // 🎯 Add metadata (including customer info for tracking)
        'metadata': {
          'app_user_id': _authController.userId,
          'user_name': _authController.displayName,
          'user_email': _authController.userEmail,
          'user_phone': customerPhone ?? _authController.phoneNumber,
          'user_nationality': customerNationality ?? '',
          ...?metadata,
        },
      };

      print(
          '📤 Creating payment intent with customer data for real customer creation');
      print('📤 Customer Info: ${intentPayload['customerInfo']}');

      // Make API call to your backend
      final response = await _authController.dioClient.post(
        'https://api.royaldusk.com/payment-service/payment/create-intent',
        data: intentPayload,
      );

      // Handle successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;

        // 🎯 Log the response to see customer creation
        print('📦 Backend response: ${responseData.toString()}');

        // Log customer creation details
        if (responseData['customerId'] != null) {
          print(
              '✅ Stripe customer created/updated: ${responseData['customerId']}');
          print(
              '✅ Customer type: ${responseData['customerType'] ?? 'real_customer'}');
        }

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

        // Retrieve the PaymentIntent using Stripe SDK
        _currentPaymentIntent = await Stripe.instance.retrievePaymentIntent(
          extractedClientSecret,
        );

        if (_currentPaymentIntent != null) {
          lastCreatedIntentId.value = _currentPaymentIntent!.id;
          intentStatus.value = PaymentIntentStatus.created;

          print(
              '✅ Payment intent created successfully: ${lastCreatedIntentId.value}');
          // print('✅ Linked to customer: ${_currentPaymentIntent!.customer ?? 'none'}');

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

  /// Present payment sheet with pre-filled customer details
  Future<PaymentIntent?> presentPaymentSheet() async {
    if (_currentPaymentIntent == null || clientSecret.value.isEmpty) {
      throw Exception(
          'No payment intent found. Please create payment intent first.');
    }

    isProcessingPayment.value = true;
    paymentStatus.value = PaymentStatus.processing;
    lastPaymentError.value = '';

    try {
      // Initialize payment sheet with pre-filled customer information
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret.value,
          merchantDisplayName: 'Royal Dusk',
          customerEphemeralKeySecret: null,
          customerId: _authController.userId,
          style: ThemeMode.system,

          // Pre-fill customer billing details
          billingDetails: BillingDetails(
            name: _authController.displayName.isNotEmpty
                ? _authController.displayName
                : null,
            email: _authController.userEmail.isNotEmpty
                ? _authController.userEmail
                : null,
            phone: _authController.phoneNumber.isNotEmpty
                ? _authController.phoneNumber
                : null,
          ),

          // Configure what information to collect
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
                  name: CollectionMode.always,
                  email: CollectionMode.always,
                  phone: CollectionMode.always),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // If we reach here, payment was successful
      paymentStatus.value = PaymentStatus.success;

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
    final Map<String, String> errors = {};

    // Booking ID validation
    if (bookingId.trim().isEmpty) {
      errors['bookingId'] = 'Booking ID is required';
    }

    // Amount validation
    if (amount <= 0) {
      errors['amount'] = 'Amount must be greater than zero';
    } else {
      final minAmount = paymentConfig['minAmount'] ?? 1.0;
      final maxAmount = paymentConfig['maxAmount'] ?? 50000.0;

      if (amount < minAmount) {
        errors['amount'] =
            'Amount must be at least \$${minAmount.toStringAsFixed(2)}';
      } else if (amount > maxAmount) {
        errors['amount'] =
            'Amount cannot exceed \$${maxAmount.toStringAsFixed(2)}';
      }
    }

    // Currency validation
    if (currency.trim().isEmpty) {
      errors['currency'] = 'Currency is required';
    } else if (currency.length != 3) {
      errors['currency'] = 'Invalid currency code';
    }

    // Auth validation
    if (_authController.userId.isEmpty) {
      errors['auth'] = 'User ID not found. Please log in again';
    }

    // Update form errors for UI
    paymentFormErrors.assignAll(errors);

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
        if (errorData['message'] != null) {
          return errorData['message'].toString();
        }
        if (errorData['error'] != null) {
          return errorData['error'].toString();
        }
      }
    }

    // Handle HTTP status codes
    switch (e.response?.statusCode) {
      case 400:
        return 'Invalid payment data. Please check your information and try again.';
      case 401:
        return 'Authentication expired. Please log in again.';
      case 404:
        return 'Booking not found. Please verify the booking details.';
      case 500:
        return 'Payment service error. Please try again later.';
      default:
        return 'Failed to process payment. Please try again.';
    }
  }

  /// Clear form errors
  void clearPaymentErrors() {
    paymentFormErrors.clear();
    lastPaymentError.value = '';
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

  // Convenience getters
  bool get isLoading =>
      isProcessingPayment.value || isCreatingPaymentIntent.value;
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
