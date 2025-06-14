import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'auth_controller.dart';

/// Payment methods supported by the system
enum PaymentMethod { card, wallet, bank }

/// Payment providers supported by the system
enum PaymentProvider { stripe, paypal, razorpay }

/// Payment status tracking
enum PaymentStatus { idle, processing, success, failed, cancelled }

/// Payment intent creation states
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
  }

  /// Load payment configuration from API or local storage
  Future<void> _loadPaymentConfiguration() async {
    try {
      // You can load payment configuration from API if needed
      paymentConfig.assignAll({
        'supportedMethods': ['card', 'wallet'],
        'supportedProviders': ['stripe'],
        'defaultCurrency': 'AED',
        'minAmount': 1.0,
        'maxAmount': 50000.0,
      });
    } catch (e) {
      print('⚠️ Failed to load payment configuration: $e');
    }
  }

  /// Create payment intent with comprehensive validation and error handling
  Future<Map<String, dynamic>?> createPaymentIntent({
    required String bookingId,
    required double amount,
    String currency = 'AED',
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
      // Prepare payment intent payload
      final intentPayload = _buildPaymentIntentPayload(
        bookingId: bookingId,
        amount: amount,
        currency: currency,
        provider: provider,
        method: method,
        metadata: metadata,
      );

      print(
          '📤 Creating payment intent with payload: ${intentPayload.toString()}');

      // Make API call
      final response = await _authController.dioClient.post(
        '/payment-service/payment/create-intent',
        data: intentPayload,
      );

      // Handle successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract payment intent data from response
        final intentData = _extractPaymentIntentData(responseData);

        if (intentData != null) {
          lastCreatedIntentId.value = intentData['intentId'] ?? '';
          clientSecret.value = intentData['clientSecret'] ?? '';
          intentStatus.value = PaymentIntentStatus.created;

          print(
              '✅ Payment intent created successfully: ${lastCreatedIntentId.value}');

          // Store intent data for later use
          _storePaymentIntentData(intentData);
        }

        return responseData;
      } else {
        throw Exception('Unexpected response status: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      print('❌ Dio Exception during payment intent creation');
      print('📊 Status code: ${e.response?.statusCode}');
      print('📦 Error response: ${e.response?.data}');

      final errorMessage = _parsePaymentError(e);
      lastPaymentError.value = errorMessage;
      intentStatus.value = PaymentIntentStatus.failed;
      throw Exception(errorMessage);
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

  /// Build payment intent payload from provided data
  Map<String, dynamic> _buildPaymentIntentPayload({
    required String bookingId,
    required double amount,
    required String currency,
    required PaymentProvider provider,
    required PaymentMethod method,
    Map<String, dynamic>? metadata,
  }) {
    // Convert amount to smallest currency unit (cents for most currencies)
    final amountInCents = _convertToSmallestUnit(amount, currency);

    final payload = {
      'bookingId': bookingId.trim(),
      'amount': amountInCents,
      'currency': currency.toUpperCase(),
      'provider': _getProviderString(provider),
      'method': _getMethodString(method),
    };

    // Add user information
    payload['userId'] = _authController.userId;
    payload['userEmail'] = _authController.userEmail;

    // Add metadata if provided
    if (metadata != null && metadata.isNotEmpty) {
      payload['metadata'] = metadata;
    }

    // Add customer information for better payment processing
    payload['customer'] = {
      'id': _authController.userId,
      'email': _authController.userEmail,
      'name': _authController.displayName,
    };

    return payload;
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
    } else if (!_isValidUUID(bookingId)) {
      errors['bookingId'] = 'Invalid booking ID format';
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
    isPaymentFormValid.value = errors.isEmpty;

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'error': errors.isNotEmpty ? errors.values.first : null,
    };
  }

  /// Check if string is valid UUID format
  bool _isValidUUID(String uuid) {
    final uuidRegex = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    return uuidRegex.hasMatch(uuid.trim());
  }

  /// Extract payment intent data from response
  Map<String, dynamic>? _extractPaymentIntentData(
      Map<String, dynamic> response) {
    // Try different possible response structures
    Map<String, dynamic>? intentData;

    if (response['data'] != null) {
      intentData = response['data'] as Map<String, dynamic>?;
    } else if (response['paymentIntent'] != null) {
      intentData = response['paymentIntent'] as Map<String, dynamic>?;
    } else {
      intentData = response;
    }

    if (intentData != null) {
      return {
        'intentId': intentData['id'] ??
            intentData['intentId'] ??
            intentData['payment_intent_id'],
        'clientSecret':
            intentData['client_secret'] ?? intentData['clientSecret'],
        'status': intentData['status'],
        'amount': intentData['amount'],
        'currency': intentData['currency'],
        'created':
            intentData['created'] ?? DateTime.now().millisecondsSinceEpoch,
      };
    }

    return null;
  }

  /// Store payment intent data locally for reference
  void _storePaymentIntentData(Map<String, dynamic> intentData) {
    // Store in memory for current session
    // You could also store in secure storage if needed
    paymentConfig['lastIntent'] = intentData;
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

  /// Confirm payment with payment method details
  Future<Map<String, dynamic>?> confirmPayment({
    required String paymentIntentId,
    required Map<String, dynamic> paymentMethodData,
  }) async {
    if (paymentIntentId.isEmpty) {
      throw Exception('Payment intent ID is required');
    }

    isProcessingPayment.value = true;
    paymentStatus.value = PaymentStatus.processing;
    lastPaymentError.value = '';

    try {
      final response = await _authController.dioClient.post(
        '/payment-service/payment/confirm',
        data: {
          'paymentIntentId': paymentIntentId,
          'paymentMethod': paymentMethodData,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        paymentStatus.value = PaymentStatus.success;

        // Refresh payment history
        _refreshPaymentHistory();

        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Payment confirmation failed');
      }
    } on dio.DioException catch (e) {
      final errorMessage = _parsePaymentError(e);
      lastPaymentError.value = errorMessage;
      paymentStatus.value = PaymentStatus.failed;
      throw Exception(errorMessage);
    } catch (e) {
      lastPaymentError.value = 'Payment confirmation failed';
      paymentStatus.value = PaymentStatus.failed;
      throw Exception(lastPaymentError.value);
    } finally {
      isProcessingPayment.value = false;
    }
  }

  /// Fetch user's payment history
  Future<void> fetchPaymentHistory() async {
    if (!_authController.isValidSession) {
      return;
    }

    isLoadingPaymentHistory.value = true;

    try {
      final response = await _authController.dioClient.get(
        '/payment-service/payment/history/${_authController.userId}',
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

  /// Get payment by ID
  Future<Map<String, dynamic>?> getPaymentById(String paymentId) async {
    if (!_authController.isValidSession || paymentId.isEmpty) {
      return null;
    }

    try {
      final response = await _authController.dioClient.get(
        '/payment-service/payment/$paymentId',
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print('❌ Error fetching payment $paymentId: $e');
    }
    return null;
  }

  /// Cancel/refund payment
  Future<bool> refundPayment(String paymentId,
      {double? amount, String? reason}) async {
    if (!_authController.isValidSession || paymentId.isEmpty) {
      return false;
    }

    try {
      final response = await _authController.dioClient.post(
        '/payment-service/payment/$paymentId/refund',
        data: {
          'amount': amount,
          'reason': reason ?? 'Customer requested refund',
        },
      );

      if (response.statusCode == 200) {
        // Refresh payment history after refund
        _refreshPaymentHistory();
        return true;
      }
    } catch (e) {
      print('❌ Error refunding payment $paymentId: $e');
    }
    return false;
  }

  /// Validate payment form and update state
  void validatePaymentForm({
    String? bookingId,
    double? amount,
    String? currency,
  }) {
    if (bookingId != null && amount != null && currency != null) {
      _validatePaymentIntentData(
        bookingId: bookingId,
        amount: amount,
        currency: currency,
      );
    }
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

  @override
  void onClose() {
    _resetPaymentState();
    super.onClose();
  }
}
