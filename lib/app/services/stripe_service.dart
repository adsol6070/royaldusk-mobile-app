import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static const String _publishableKey =
      'pk_test_51RURHOQVAwzUHOUyjXieJKJ091m2ALCO0hklQuaQti4NDrcywPdSp2ZGxt7gkybh8HKcswYRbOcM5v5ND9D16hbT00wazSv0Zr'; // Replace with your actual publishable key

  static bool _isInitialized = false;

  /// Initialize Stripe with your publishable key
  /// Call this in your main.dart or app initialization
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      Stripe.publishableKey = _publishableKey;

      // Configure Stripe settings
      await Stripe.instance.applySettings();

      _isInitialized = true;
      print('✅ Stripe initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Stripe: $e');
      rethrow;
    }
  }

  /// Check if Stripe is properly initialized
  static bool get isInitialized => _isInitialized;

  /// Validate that Stripe is ready for use
  static void ensureInitialized() {
    if (!_isInitialized) {
      throw Exception(
          'Stripe must be initialized before use. Call StripeService.init() first.');
    }
  }

  /// Create payment method from card details
  static Future<PaymentMethod> createPaymentMethod({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    required String cardHolderName,
    String? email,
  }) async {
    ensureInitialized();

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: cardHolderName,
              email: email,
            ),
          ),
        ),
      );

      return paymentMethod;
    } catch (e) {
      print('❌ Error creating payment method: $e');
      rethrow;
    }
  }

  /// Confirm payment with card details
  static Future<PaymentIntent> confirmPayment({
    required String clientSecret,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    required String cardHolderName,
    String? email,
  }) async {
    ensureInitialized();

    try {
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: cardHolderName,
              email: email,
            ),
          ),
        ),
      );

      return paymentIntent;
    } catch (e) {
      print('❌ Error confirming payment: $e');
      rethrow;
    }
  }

  /// Present Stripe payment sheet
  static Future<void> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
    String? customerId,
    String? customerEphemeralKeySecret,
    ThemeMode? themeMode,
  }) async {
    ensureInitialized();

    try {
      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          style: themeMode ?? ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFF6366F1), // Your app primary color
            ),
          ),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('❌ Error presenting payment sheet: $e');
      rethrow;
    }
  }

  /// Retrieve payment intent
  static Future<PaymentIntent> retrievePaymentIntent(
      String clientSecret) async {
    ensureInitialized();

    try {
      final paymentIntent =
          await Stripe.instance.retrievePaymentIntent(clientSecret);
      return paymentIntent;
    } catch (e) {
      print('❌ Error retrieving payment intent: $e');
      rethrow;
    }
  }

  /// Handle 3D Secure authentication
  static Future<PaymentIntent> handleNextAction(String clientSecret) async {
    ensureInitialized();

    try {
      final paymentIntent =
          await Stripe.instance.handleNextAction(clientSecret);
      return paymentIntent;
    } catch (e) {
      print('❌ Error handling next action: $e');
      rethrow;
    }
  }

  /// Get Stripe error message from exception
  static String getErrorMessage(dynamic error) {
    if (error is StripeException) {
      return error.error.localizedMessage ??
          'An error occurred with payment processing';
    }
    return error.toString();
  }

  /// Check if error is user cancellation
  static bool isUserCancellation(dynamic error) {
    if (error is StripeException) {
      return error.error.code == FailureCode.Canceled;
    }
    return false;
  }

  /// Format card number for display
  static String formatCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < cleanNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleanNumber[i]);
    }

    return buffer.toString();
  }

  /// Format expiry date for display
  static String formatExpiryDate(String expiryDate) {
    final cleanDate = expiryDate.replaceAll(RegExp(r'\D'), '');
    if (cleanDate.length >= 2) {
      final month = cleanDate.substring(0, 2);
      final year = cleanDate.length > 2
          ? cleanDate.substring(2, cleanDate.length.clamp(0, 4))
          : '';
      return year.isEmpty ? month : '$month/$year';
    }
    return cleanDate;
  }

  /// Validate card number using Luhn algorithm
  static bool isValidCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }

    int sum = 0;
    bool alternate = false;

    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);

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
  static bool isValidExpiryDate(String expiryDate) {
    final cleanDate = expiryDate.replaceAll(RegExp(r'\D'), '');

    if (cleanDate.length != 4) return false;

    final month = int.tryParse(cleanDate.substring(0, 2));
    final year = int.tryParse('20${cleanDate.substring(2)}');

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiry = DateTime(year, month);
    final currentMonth = DateTime(now.year, now.month);

    return expiry.isAfter(currentMonth) ||
        expiry.isAtSameMomentAs(currentMonth);
  }

  /// Get card type from card number
  static String getCardType(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.startsWith('4')) {
      return 'Visa';
    } else if (cleanNumber.startsWith(RegExp(r'5[1-5]')) ||
        cleanNumber.startsWith(RegExp(r'2[2-7]'))) {
      return 'Mastercard';
    } else if (cleanNumber.startsWith(RegExp(r'3[47]'))) {
      return 'American Express';
    } else if (cleanNumber.startsWith('6')) {
      return 'Discover';
    } else if (cleanNumber.startsWith(RegExp(r'3[0689]'))) {
      return 'Diners Club';
    } else if (cleanNumber.startsWith('35')) {
      return 'JCB';
    }

    return 'Unknown';
  }
}
