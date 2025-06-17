import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import '../../controller/payment_controller.dart';
import '../../model/popular_packages.dart';
import 'booking_success_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late PaymentController controller;

  // Get booking data from arguments
  Map<String, dynamic>? get bookingData =>
      Get.arguments as Map<String, dynamic>?;

  bool get isDarkMode {
    try {
      // Try to get theme controller if it exists
      final themeController =
          Get.find<dynamic>(); // Replace with your actual theme controller type
      return themeController?.isDarkMode ?? false;
    } catch (e) {
      // Fallback to system theme if no theme controller found
      return Theme.of(context).brightness == Brightness.dark;
    }
  }

  // Form controllers for Stripe
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Card type detection
  String cardType = '';
  bool isPromoApplied = false;
  double discountAmount = 0.0;

  // Payment processing states
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = PaymentController.to;

    // Listen to payment status changes
    _setupPaymentListeners();
  }

  void _setupPaymentListeners() {
    // Listen to payment status changes
    ever(controller.paymentStatus, (PaymentStatus status) {
      switch (status) {
        case PaymentStatus.success:
          _handlePaymentSuccess();
          break;
        case PaymentStatus.failed:
          _handlePaymentFailure();
          break;
        case PaymentStatus.cancelled:
          _handlePaymentCancellation();
          break;
        default:
          break;
      }
    });

    // Listen to payment errors
    ever(controller.lastPaymentError, (String error) {
      if (error.isNotEmpty && _isProcessing) {
        _showErrorSnackBar(error);
      }
    });
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardHolderController.dispose();
    promoCodeController.dispose();
    super.dispose();
  }

  // Get booking details
  PopularPackage? get package => bookingData?['package'] as PopularPackage?;
  DateTime? get startDate => bookingData?['startDate'] as DateTime?;
  int get travelerCount => bookingData?['travelerCount'] as int? ?? 1;
  String get phoneNumber => bookingData?['phoneNumber'] as String? ?? '';
  double get totalPrice => bookingData?['totalPrice'] as double? ?? 0.0;
  String get currency => bookingData?['currency'] as String? ?? '\$';
  String get bookingId {
    print('🔍 PaymentScreen - bookingData: $bookingData');
    print(
        '🔍 PaymentScreen - bookingData?[bookingId]: ${bookingData?['bookingId']}');

    final id = bookingData?['bookingId'] as String? ?? '';
    print('🔍 PaymentScreen - final bookingId: $id');

    return id;
  }

  double get finalAmount => totalPrice - discountAmount;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: isDarkMode ? appDarkBgColor : whiteColor,
        appBar: commonAppBarWidget(context, titleText: "Payment"),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Summary Card
                    _buildBookingSummaryCard(),
                    25.height,

                    // Payment Section Header
                    _buildSectionHeader("Payment Details", Icons.payment),
                    20.height,

                    // Stripe Logo and Secure Payment Info
                    _buildStripeHeader(),
                    25.height,

                    // Payment Method Selection
                    _buildPaymentMethodSelection(),
                    25.height,

                    // Card Details Section (only show if card payment is selected)
                    if (!_isUsingPaymentSheet()) ...[
                      // Card Holder Name
                      _buildCardHolderField(),
                      20.height,

                      // Card Number
                      _buildCardNumberField(),
                      20.height,

                      // Expiry and CVV Row
                      Row(
                        children: [
                          Expanded(child: _buildExpiryField()),
                          15.width,
                          Expanded(child: _buildCVVField()),
                        ],
                      ),
                      25.height,
                    ],

                    // Promo Code Section
                    _buildPromoCodeSection(),
                    25.height,

                    // Price Breakdown
                    _buildPriceBreakdown(),
                    30.height,

                    // Security Features
                    _buildSecurityFeatures(),
                    30.height,

                    // Payment Error Display
                    if (controller.hasError) ...[
                      _buildErrorDisplay(),
                      20.height,
                    ],

                    // Pay Now Button
                    _buildPayNowButton(),
                    20.height,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBookingSummaryCard() {
    if (package == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? appTextColorPrimary.withAlpha(26)
            : appColorPrimary.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appColorPrimary.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: commonCacheImageWidget(
                  package!.imageUrl,
                  50,
                  fit: BoxFit.cover,
                  width: 50,
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package!.name,
                      style: const TextStyle(
                        fontSize: textSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
                    Text(
                      package!.location.name,
                      style: TextStyle(
                        fontSize: textSizeSmall,
                        color: isDarkMode
                            ? whiteColor.withAlpha(153)
                            : appTextColorPrimary.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          Divider(
            color: isDarkMode
                ? whiteColor.withAlpha(26)
                : appTextColorPrimary.withAlpha(26),
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Travelers: $travelerCount",
                style: TextStyle(
                  fontSize: textSizeSmall,
                  color: isDarkMode
                      ? whiteColor.withAlpha(153)
                      : appTextColorPrimary.withAlpha(153),
                ),
              ),
              if (startDate != null)
                Text(
                  "Date: ${startDate!.day}/${startDate!.month}/${startDate!.year}",
                  style: TextStyle(
                    fontSize: textSizeSmall,
                    color: isDarkMode
                        ? whiteColor.withAlpha(153)
                        : appTextColorPrimary.withAlpha(153),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: appColorPrimary, size: 24),
        12.width,
        Text(
          title,
          style: TextStyle(
            fontSize: textSizeLargeMedium,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildStripeHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? appTextColorPrimary.withAlpha(13)
            : Colors.blue.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withAlpha(51),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "stripe",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Secure Payment",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textSizeMedium,
                  ),
                ),
                4.height,
                Text(
                  "Your payment information is encrypted and secure",
                  style: TextStyle(
                    fontSize: textSizeSmall,
                    color: isDarkMode
                        ? whiteColor.withAlpha(153)
                        : appTextColorPrimary.withAlpha(153),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.security, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        12.height,
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodOption(
                "Manual Entry",
                Icons.credit_card,
                !_isUsingPaymentSheet(),
                () => setState(() {}),
              ),
            ),
            12.width,
            Expanded(
              child: _buildPaymentMethodOption(
                "Stripe Checkout",
                Icons.payment,
                _isUsingPaymentSheet(),
                () => setState(() {}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? appColorPrimary.withAlpha(26)
              : (isDarkMode
                  ? appTextColorPrimary.withAlpha(13)
                  : Colors.grey.withAlpha(26)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? appColorPrimary
                : (isDarkMode
                    ? whiteColor.withAlpha(51)
                    : appTextColorPrimary.withAlpha(51)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? appColorPrimary
                  : (isDarkMode ? whiteColor : appTextColorPrimary),
              size: 24,
            ),
            8.height,
            Text(
              title,
              style: TextStyle(
                fontSize: textSizeSmall,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? appColorPrimary
                    : (isDarkMode ? whiteColor : appTextColorPrimary),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHolderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cardholder Name *",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        8.height,
        TextFormField(
          controller: cardHolderController,
          style: TextStyle(
            fontSize: textSizeMedium,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
          decoration: _buildInputDecoration(
            hintText: "Enter cardholder name",
            prefixIcon: Icons.person,
            errorText: controller.getFieldError('cardHolderName'),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cardholder name is required';
            }
            return null;
          },
          onChanged: (value) => _validateForm(),
        ),
      ],
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Card Number *",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        8.height,
        TextFormField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CardNumberFormatter(),
          ],
          style: TextStyle(
            fontSize: textSizeMedium,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
          decoration: _buildInputDecoration(
            hintText: "1234 5678 9012 3456",
            prefixIcon: Icons.credit_card,
            suffixWidget: _getCardTypeIcon(),
            errorText: controller.getFieldError('cardNumber'),
          ),
          onChanged: (value) {
            setState(() {
              cardType = _getCardType(value);
            });
            _validateForm();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Card number is required';
            }
            if (value.replaceAll(' ', '').length < 16) {
              return 'Please enter a valid card number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildExpiryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Expiry Date *",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        8.height,
        TextFormField(
          controller: expiryController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ExpiryDateFormatter(),
          ],
          style: TextStyle(
            fontSize: textSizeMedium,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
          decoration: _buildInputDecoration(
            hintText: "MM/YY",
            prefixIcon: Icons.calendar_today,
            errorText: controller.getFieldError('expiryDate'),
          ),
          onChanged: (value) => _validateForm(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Expiry date required';
            }
            if (value.length < 5) {
              return 'Invalid expiry date';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCVVField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CVV *",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        8.height,
        TextFormField(
          controller: cvvController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          obscureText: true,
          style: TextStyle(
            fontSize: textSizeMedium,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
          decoration: _buildInputDecoration(
            hintText: "123",
            prefixIcon: Icons.lock,
            errorText: controller.getFieldError('cvv'),
          ),
          onChanged: (value) => _validateForm(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'CVV required';
            }
            if (value.length < 3) {
              return 'Invalid CVV';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Promo Code (Optional)",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        8.height,
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkMode
                  ? whiteColor.withAlpha(51)
                  : appTextColorPrimary.withAlpha(51),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: promoCodeController,
                  style: TextStyle(
                    fontSize: textSizeMedium,
                    color: isDarkMode ? whiteColor : appTextColorPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter promo code",
                    hintStyle: TextStyle(
                      color: isDarkMode
                          ? whiteColor.withAlpha(153)
                          : appTextColorPrimary.withAlpha(153),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: _applyPromoCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    isPromoApplied ? "Applied" : "Apply",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isPromoApplied) ...[
          8.height,
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(26),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withAlpha(51)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                8.width,
                Text(
                  "Promo code applied! You saved $currency${discountAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: textSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? appTextColorPrimary.withAlpha(26)
            : appColorPrimary.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Price Breakdown",
            style: TextStyle(
              fontSize: textSizeMedium,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.ubuntu().fontFamily,
            ),
          ),
          12.height,
          _buildPriceRow("Package Price",
              "$currency${package?.price ?? 0} x $travelerCount", totalPrice),
          if (isPromoApplied) ...[
            8.height,
            _buildPriceRow("Discount", "Promo Applied", -discountAmount,
                color: Colors.green),
          ],
          12.height,
          Divider(
            color: isDarkMode
                ? whiteColor.withAlpha(26)
                : appTextColorPrimary.withAlpha(26),
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: textSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$currency${finalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: textSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: appColorPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String description, double amount,
      {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: textSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (description.isNotEmpty) ...[
                2.height,
                Text(
                  description,
                  style: TextStyle(
                    fontSize: textSizeSmall,
                    color: isDarkMode
                        ? whiteColor.withAlpha(153)
                        : appTextColorPrimary.withAlpha(153),
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          "${amount < 0 ? '-' : ''}$currency${amount.abs().toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityFeatures() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withAlpha(51)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: Colors.green, size: 20),
              8.width,
              const Expanded(
                child: Text(
                  "Your payment is protected by 256-bit SSL encryption",
                  style: TextStyle(
                    fontSize: textSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              const Icon(Icons.verified_user, color: Colors.green, size: 20),
              8.width,
              const Expanded(
                child: Text(
                  "PCI DSS compliant payment processing",
                  style: TextStyle(
                    fontSize: textSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withAlpha(51)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 20),
          12.width,
          Expanded(
            child: Text(
              controller.errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: textSizeSmall,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: controller.clearPaymentErrors,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton() {
    return GradientElevatedButton(
      onPressed: controller.isLoading || !_canProcessPayment()
          ? () {}
          : _processPayment,
      text: controller.isLoading
          ? "Processing..."
          : "Pay $currency${finalAmount.toStringAsFixed(2)}",
      height: 55,
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixWidget,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDarkMode
            ? whiteColor.withAlpha(153)
            : appTextColorPrimary.withAlpha(153),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: appColorPrimary,
        size: 20,
      ),
      suffixIcon: suffixWidget,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDarkMode
              ? whiteColor.withAlpha(51)
              : appTextColorPrimary.withAlpha(51),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDarkMode
              ? whiteColor.withAlpha(51)
              : appTextColorPrimary.withAlpha(51),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: appColorPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  Widget _getCardTypeIcon() {
    switch (cardType) {
      case 'Visa':
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'VISA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 'Mastercard':
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'MC',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 'American Express':
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'AMEX',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getCardType(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith(RegExp(r'5[1-5]')) ||
        cardNumber.startsWith(RegExp(r'2[2-7]'))) {
      return 'Mastercard';
    } else if (cardNumber.startsWith(RegExp(r'3[47]'))) {
      return 'American Express';
    }
    return '';
  }

  bool _isUsingPaymentSheet() {
    // You can add logic here to determine payment method
    // For now, default to manual entry
    return false;
  }

  bool _canProcessPayment() {
    if (bookingId.isEmpty || finalAmount <= 0) return false;

    if (_isUsingPaymentSheet()) {
      return true; // Stripe will handle validation
    } else {
      return _formKey.currentState?.validate() ?? false;
    }
  }

  void _validateForm() {
    if (!_isUsingPaymentSheet()) {
      controller.validateCardDetails(
        cardNumber: cardNumberController.text,
        expiryDate: expiryController.text,
        cvv: cvvController.text,
        cardHolderName: cardHolderController.text,
      );
    }
  }

  void _applyPromoCode() {
    String promoCode = promoCodeController.text.trim().toUpperCase();

    if (promoCode.isEmpty) {
      _showErrorSnackBar('Please enter a promo code');
      return;
    }

    // Mock promo code validation
    if (promoCode == 'SAVE10') {
      setState(() {
        isPromoApplied = true;
        discountAmount = totalPrice * 0.1; // 10% discount
      });
      _showSuccessSnackBar('Promo code applied successfully!');
    } else {
      _showErrorSnackBar('Invalid promo code');
    }
  }

  void _processPayment() async {
    print('🔍 PROCESS_PAYMENT - Called _processPayment');
    print(
        '🔍 PROCESS_PAYMENT - Get.arguments at payment time: ${Get.arguments}');

    // Call bookingId getter and see what happens
    final currentBookingId = bookingId;
    print('🔍 PROCESS_PAYMENT - bookingId from getter: "$currentBookingId"');

    final currentFinalAmount = finalAmount;
    print('🔍 PROCESS_PAYMENT - finalAmount from getter: $currentFinalAmount');

    if (!_canProcessPayment()) {
      print('❌ PROCESS_PAYMENT - _canProcessPayment returned false');
      return;
    }

    try {
      _isProcessing = true;
      controller.clearPaymentErrors();
      _showLoadingDialog();

      print('🔍 PROCESS_PAYMENT - About to call createPaymentIntent');
      print('🔍 PROCESS_PAYMENT - Will pass bookingId: "$currentBookingId"');
      print('🔍 PROCESS_PAYMENT - Will pass amount: $currentFinalAmount');

      await controller.createPaymentIntent(
        bookingId: currentBookingId,
        amount: currentFinalAmount,
        currency: 'usd',
        metadata: {
          'package_name': package?.name ?? '',
          'traveler_count': travelerCount.toString(),
          'promo_applied': isPromoApplied.toString(),
          if (isPromoApplied) 'discount_amount': discountAmount.toString(),
        },
      );

      // Close loading dialog
      Get.back();

      // Process payment based on selected method
      if (_isUsingPaymentSheet()) {
        await controller.presentPaymentSheet();
      } else {
        // Validate form one more time
        if (!_formKey.currentState!.validate()) {
          _showErrorSnackBar('Please fill in all required fields correctly');
          return;
        }

        await controller.confirmPaymentWithCard(
          cardNumber: cardNumberController.text,
          expiryDate: expiryController.text,
          cvv: cvvController.text,
          cardHolderName: cardHolderController.text,
          billingDetails: BillingDetails(
            name: cardHolderController.text,
            // email: controller._authController.userEmail,
          ),
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('❌ Payment processing error: $e');
      _showErrorSnackBar(e.toString());
    } finally {
      _isProcessing = false;
    }
  }

  void _handlePaymentSuccess() {
    _isProcessing = false;

    // Close any open dialogs
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    // Show success dialog
    BookingSuccessDialog().customDialog(context, isDarkMode);
  }

  void _handlePaymentFailure() {
    _isProcessing = false;

    // Close any open dialogs
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void _handlePaymentCancellation() {
    _isProcessing = false;

    // Close any open dialogs
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    _showErrorSnackBar('Payment was cancelled');
  }

  void _showLoadingDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button during processing
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing Payment...'),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// Card number formatter
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');
    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Expiry date formatter
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    String formatted = '';

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        formatted += '/';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
