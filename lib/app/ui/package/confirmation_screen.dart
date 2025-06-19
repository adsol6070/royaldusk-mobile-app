import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/app/controller/payment_controller.dart';
import 'package:royaldusk_mobile_app/app/model/package.dart';
import 'package:royaldusk_mobile_app/app/ui/package/booking_success_dialog.dart';

import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/custom_row_text_with_click.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
// import '../../../route/my_route.dart';
import '../../controller/confirmation_controller.dart';
import '../../controller/auth_controller.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  ConfirmationScreenState createState() => ConfirmationScreenState();
}

class ConfirmationScreenState extends State<ConfirmationScreen> {
  late ConfirmationController controller;
  late AuthController authController;
  late PaymentController paymentController;

  bool get isDarkMode {
    try {
      final themeController = Get.find<dynamic>();
      return themeController?.isDarkMode ?? false;
    } catch (e) {
      return Theme.of(context).brightness == Brightness.dark;
    }
  }

  Package? get package => Get.arguments as Package?;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  DateTime? selectedStartDate;
  int travelerCount = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConfirmationController(), tag: 'travel_confirmation');
    authController = AuthController.to;
    paymentController = Get.put(PaymentController());

    if (package != null) {
      travelerCount = 1;
    }

    if (authController.phoneNumber.isNotEmpty) {
      phoneController.text = authController.phoneNumber;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    nationalityController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  double get totalPrice {
    if (package != null) {
      return package!.price * travelerCount;
    }
    return 0.0;
  }

  String get currency {
    return package?.currency ?? '\$';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmationController>(
        init: controller,
        tag: 'travel_confirmation',
        builder: (controller) {
          return Scaffold(
            backgroundColor: isDarkMode ? appDarkBgColor : whiteColor,
            appBar:
                commonAppBarWidget(context, titleText: "Booking Confirmation"),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Package Summary Card
                        _buildPackageSummaryCard(),
                        20.height,

                        // Show authentication info
                        _buildAuthInfoCard(),
                        20.height,

                        Text(
                          "Trip Details",
                          style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.ubuntu().fontFamily),
                        ),
                        20.height,

                        // Start Date Selection
                        _buildDateSelection(),
                        20.height,

                        // Destination
                        _buildDestinationInfo(),
                        20.height,

                        // Duration
                        _buildDurationInfo(),
                        20.height,

                        // Hotel Info
                        _buildHotelInfo(),
                        20.height,

                        // Phone Number Input
                        _buildPhoneNumberInput(),
                        20.height,

                        // Nationality Input
                        _buildNationalityInput(),
                        20.height,

                        // Remarks Input
                        _buildRemarksInput(),
                        20.height,

                        // Travelers Count
                        _buildTravelersSection(),
                        10.height,

                        // Price Info
                        _buildPriceInfo(),
                        10.height,

                        Divider(
                          color: isDarkMode
                              ? whiteColor.withAlpha(26)
                              : appTextColorPrimary.withAlpha(26),
                        ),
                        10.height,

                        // Total
                        _buildTotalSection(),
                        30.height,

                        // Show any booking errors
                        Obx(() => controller.hasError
                            ? _buildErrorWidget()
                            : const SizedBox.shrink()),

                        // Show payment errors
                        Obx(() => paymentController.hasError
                            ? _buildPaymentErrorWidget()
                            : const SizedBox.shrink()),

                        // Continue Button with payment integration
                        Obx(() => GradientElevatedButton(
                            onPressed: _isLoading
                                ? () {}
                                : _handleCreateBookingWithPayment,
                            text: _getButtonText())),

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

  Widget _buildPaymentErrorWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withAlpha(51)),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: Colors.red, size: 24),
          12.width,
          Expanded(
            child: Text(
              paymentController.errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isLoading =>
      controller.isLoading ||
      paymentController.isCreatingPaymentIntent.value ||
      paymentController.isProcessingPayment.value;

  String _getButtonText() {
    if (controller.isLoading) {
      return "Creating Booking...";
    } else if (paymentController.isCreatingPaymentIntent.value) {
      return "Setting up Payment...";
    } else if (paymentController.isProcessingPayment.value) {
      return "Processing Payment...";
    }
    return "Create Booking & Pay";
  }

  Widget _buildAuthInfoCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? appTextColorPrimary.withAlpha(26)
                : Colors.blue.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue, size: 20),
                  8.width,
                  Text(
                    'Booking for:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: textSizeSmall,
                      color: isDarkMode
                          ? whiteColor.withAlpha(153)
                          : appTextColorPrimary.withAlpha(153),
                    ),
                  ),
                ],
              ),
              8.height,
              Text(
                authController.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textSizeMedium,
                ),
              ),
              4.height,
              Text(
                authController.userEmail,
                style: TextStyle(
                  fontSize: textSizeSmall,
                  color: isDarkMode
                      ? whiteColor.withAlpha(153)
                      : appTextColorPrimary.withAlpha(153),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withAlpha(51)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 24),
          12.width,
          Expanded(
            child: Text(
              controller.errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSummaryCard() {
    if (package == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withAlpha(51)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 24),
            12.width,
            const Expanded(
              child: Text(
                'No package information found. Please go back and select a package.',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? appTextColorPrimary.withAlpha(26)
            : appColorPrimary.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: commonCacheImageWidget(
              package!.imageUrl,
              60,
              fit: BoxFit.cover,
              width: 60,
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
                4.height,
                if (package!.tag.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: appColorPrimary.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      package!.tag,
                      style: const TextStyle(
                        color: appColorPrimary,
                        fontSize: textSizeSmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowTextWithClick(
            title: "Start Date",
            onPressed: _selectStartDate,
            isDarkMode: isDarkMode),
        5.height,
        GestureDetector(
          onTap: _selectStartDate,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.hasFieldError('startDate')
                    ? Colors.red
                    : (isDarkMode
                        ? whiteColor.withAlpha(51)
                        : appTextColorPrimary.withAlpha(51)),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedStartDate != null
                      ? "${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}"
                      : "Select start date",
                  style: TextStyle(
                    fontSize: textSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: selectedStartDate != null
                        ? (isDarkMode ? whiteColor : appTextColorPrimary)
                        : (isDarkMode
                            ? whiteColor.withAlpha(153)
                            : appTextColorPrimary.withAlpha(153)),
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: appColorPrimary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (controller.hasFieldError('startDate'))
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              controller.getFieldError('startDate') ?? '',
              style:
                  const TextStyle(color: Colors.red, fontSize: textSizeSmall),
            ),
          ),
      ],
    );
  }

  Widget _buildDestinationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowTextWithClick(
            title: "Destination", onPressed: () {}, isDarkMode: isDarkMode),
        5.height,
        _buildText(package?.location.name ?? 'Not specified'),
      ],
    );
  }

  Widget _buildDurationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowTextWithClick(
            title: "Duration", onPressed: () {}, isDarkMode: isDarkMode),
        5.height,
        _buildText('${package?.duration ?? 0} days'),
      ],
    );
  }

  Widget _buildHotelInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowTextWithClick(
            title: "Hotel", onPressed: () {}, isDarkMode: isDarkMode),
        5.height,
        _buildText(package?.hotels ?? 'To be confirmed'),
      ],
    );
  }

  Widget _buildPhoneNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Number *",
          style: TextStyle(
            color: isDarkMode
                ? whiteColor.withAlpha(153)
                : appTextColorPrimary.withAlpha(153),
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.height,
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
          ),
          decoration: InputDecoration(
            hintText: "Enter your phone number",
            hintStyle: TextStyle(
              color: isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              fontWeight: FontWeight.normal,
            ),
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
                color: controller.hasFieldError('phone')
                    ? Colors.red
                    : (isDarkMode
                        ? whiteColor.withAlpha(51)
                        : appTextColorPrimary.withAlpha(51)),
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
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
          onChanged: (value) => _validateFormData(),
        ),
        if (controller.hasFieldError('phone'))
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              controller.getFieldError('phone') ?? '',
              style:
                  const TextStyle(color: Colors.red, fontSize: textSizeSmall),
            ),
          ),
      ],
    );
  }

  Widget _buildNationalityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nationality",
          style: TextStyle(
            color: isDarkMode
                ? whiteColor.withAlpha(153)
                : appTextColorPrimary.withAlpha(153),
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.height,
        TextFormField(
          controller: nationalityController,
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
          ),
          decoration: InputDecoration(
            hintText: "Enter your nationality (optional)",
            hintStyle: TextStyle(
              color: isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              fontWeight: FontWeight.normal,
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Special Requests/Remarks",
          style: TextStyle(
            color: isDarkMode
                ? whiteColor.withAlpha(153)
                : appTextColorPrimary.withAlpha(153),
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.height,
        TextFormField(
          controller: remarksController,
          maxLines: 3,
          style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
          ),
          decoration: InputDecoration(
            hintText: "Any special requests or remarks (optional)",
            hintStyle: TextStyle(
              color: isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              fontWeight: FontWeight.normal,
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelersSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travelers",
              style: TextStyle(
                color: isDarkMode
                    ? whiteColor.withAlpha(153)
                    : appTextColorPrimary.withAlpha(153),
                fontSize: textSizeMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildText(
                '$travelerCount ${travelerCount == 1 ? 'Person' : 'Persons'}'),
            if (controller.hasFieldError('travelers'))
              Text(
                controller.getFieldError('travelers') ?? '',
                style:
                    const TextStyle(color: Colors.red, fontSize: textSizeSmall),
              ),
          ],
        ),
        _buildQtyPicker()
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Row(
      children: [
        SvgPicture.asset(
          infoCircleIcon,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
              isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              BlendMode.srcIn),
        ),
        5.width,
        Expanded(
          child: Text(
            'Price per person: $currency${package?.price ?? 0}',
            style: TextStyle(
                color: isDarkMode
                    ? whiteColor.withAlpha(153)
                    : appTextColorPrimary.withAlpha(153),
                fontWeight: FontWeight.w500,
                fontSize: textSizeSmall),
          ),
        )
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Amount",
          style: TextStyle(
            color: isDarkMode
                ? whiteColor.withAlpha(153)
                : appTextColorPrimary.withAlpha(153),
            fontSize: textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$currency${totalPrice.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: textSizeNormal,
              fontWeight: FontWeight.bold,
              color: appColorPrimary,
              fontFamily: GoogleFonts.ubuntu().fontFamily),
        )
      ],
    );
  }

  Widget _buildQtyPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _decrementTravelers,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? appTextColorPrimary.withAlpha(26)
                  : appColorPrimary.withAlpha(26),
              borderRadius: BorderRadius.circular(4),
            ),
            child: SvgPicture.asset(
              isDarkMode ? minusWhiteIcon : minusIcon,
              width: 20,
              height: 20,
            ),
          ),
        ),
        10.width,
        Text(
          '$travelerCount',
          style: const TextStyle(
              fontSize: textSizeNormal, fontWeight: FontWeight.bold),
        ),
        10.width,
        GestureDetector(
          onTap: _incrementTravelers,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: appColorPrimary.withAlpha(26),
              borderRadius: BorderRadius.circular(4),
            ),
            child: SvgPicture.asset(
              isDarkMode ? addWhiteIcon : addIcon,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.ubuntu().fontFamily));
  }

  void _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedStartDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColorPrimary,
              onPrimary: Colors.white,
              surface: isDarkMode ? appDarkBgColor : whiteColor,
              onSurface: isDarkMode ? whiteColor : appTextColorPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
      _validateFormData();
    }
  }

  void _incrementTravelers() {
    if (travelerCount < 10) {
      setState(() {
        travelerCount++;
      });
      _validateFormData();
    }
  }

  void _decrementTravelers() {
    if (travelerCount > 1) {
      setState(() {
        travelerCount--;
      });
      _validateFormData();
    }
  }

  void _validateFormData() {
    if (package != null && selectedStartDate != null) {
      controller.validateForm(
        package: package!,
        startDate: selectedStartDate!,
        travelers: travelerCount,
        phoneNumber: phoneController.text,
      );
    }
  }

  void _handleCreateBookingWithPayment() async {
    if (package == null) {
      _showErrorSnackBar(
          'Package information is missing. Please go back and select a package.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedStartDate == null) {
      _showErrorSnackBar('Please select a start date');
      return;
    }

    if (!authController.isValidSession) {
      _showErrorSnackBar('Please log in to create a booking');
      return;
    }

    try {
      controller.clearFormErrors();
      paymentController.clearPaymentErrors();

      final bookingResult = await controller.createBooking(
        package: package!,
        startDate: selectedStartDate!,
        travelers: travelerCount,
        phoneNumber: phoneController.text,
        nationality: nationalityController.text.isEmpty
            ? null
            : nationalityController.text,
        remarks: remarksController.text.isEmpty ? null : remarksController.text,
        agreedToTerms: true,
      );

      if (bookingResult == null ||
          controller.lastCreatedBookingId.value.isEmpty) {
        throw Exception('Failed to create booking');
      }

      final bookingId = controller.lastCreatedBookingId.value;

      await paymentController.createPaymentIntent(
        bookingId: bookingId,
        amount: totalPrice,
        currency: _getCurrencyCode(),
        provider: PaymentProvider.stripe,
        method: PaymentMethod.card,
        metadata: {
          'package_id': package!.id.toString(),
          'package_name': package!.name,
          'travelers': travelerCount.toString(),
          'start_date': selectedStartDate!.toIso8601String(),
          'user_id': authController.userId,
          'phone': phoneController.text,
        },
      );

      final paymentResult = await paymentController.presentPaymentSheet();

      if (paymentResult != null) {
        _showSuccessSnackBar(
            'Booking and payment completed successfully! Booking ID: $bookingId');

        // Navigate to booking confirmation/success screen
        // final bookingData = {
        //   'package': package,
        //   'startDate': selectedStartDate,
        //   'travelerCount': travelerCount,
        //   'phoneNumber': phoneController.text,
        //   'nationality': nationalityController.text,
        //   'remarks': remarksController.text,
        //   'totalPrice': totalPrice,
        //   'currency': currency,
        //   'bookingId': bookingId,
        //   'bookingResponse': bookingResult,
        //   'paymentIntent': paymentResult,
        //   'paymentStatus': 'completed',
        // };

        // Navigate to success screen or booking details
        // Get.offAllNamed(MyRoutes.bookingSuccessScreen, arguments: bookingData);

        BookingSuccessDialog().customDialog(context, isDarkMode);
      }
    } catch (e) {
      print('❌ Error in booking/payment flow: $e');

      String errorMessage = e.toString().replaceAll('Exception: ', '');

      if (errorMessage.contains('cancelled') ||
          errorMessage.contains('canceled')) {
        _showWarningSnackBar(
            'Payment was cancelled. Your booking has been created but payment is pending.');
      } else if (errorMessage.contains('requires additional authentication')) {
        _showWarningSnackBar(
            'Payment requires additional authentication. Please try again.');
      } else {
        _showErrorSnackBar(
            'Failed to complete booking and payment: $errorMessage');
      }
    }
  }

  String _getCurrencyCode() {
    switch (currency.toLowerCase()) {
      case 'usd':
        return 'usd';
      case '€':
      case 'eur':
        return 'eur';
      case '£':
      case 'gbp':
        return 'gbp';
      case '₹':
      case 'inr':
        return 'inr';
      case '¥':
      case 'jpy':
        return 'jpy';
      default:
        return 'usd';
    }
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
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
