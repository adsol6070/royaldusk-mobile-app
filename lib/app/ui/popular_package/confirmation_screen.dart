import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/app/controller/payment_controller.dart';

import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/custom_row_text_with_click.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
import '../../../route/my_route.dart';
import '../../controller/confirmation_controller.dart';
import '../../controller/auth_controller.dart';
import '../../model/popular_packages.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  ConfirmationScreenState createState() => ConfirmationScreenState();
}

class ConfirmationScreenState extends State<ConfirmationScreen> {
  late ConfirmationController controller;
  late AuthController authController;
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

  // Get package from arguments passed via Get.toNamed
  PopularPackage? get popularPackage => Get.arguments as PopularPackage?;

  // Form controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  DateTime? selectedStartDate;
  int travelerCount = 1;

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConfirmationController(), tag: 'travel_confirmation');
    authController = AuthController.to;
    // isDarkMode = controller.themeController.isDarkMode;

    // Set initial values if package is provided
    if (popularPackage != null) {
      travelerCount = 1; // Default to 1 person
    }

    // Pre-fill phone number if available from auth
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
    if (popularPackage != null) {
      return popularPackage!.price * travelerCount;
    }
    return 0.0;
  }

  String get currency {
    return popularPackage?.currency ?? '\$';
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

                        // Continue Button
                        Obx(() => GradientElevatedButton(
                            onPressed:
                                controller.isLoading ? () {} : _handleContinue,
                            text: controller.isLoading
                                ? "Creating Booking..."
                                : "Create Booking")),

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
    if (popularPackage == null) {
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
              popularPackage!.imageUrl,
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
                  popularPackage!.name,
                  style: const TextStyle(
                    fontSize: textSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.height,
                Text(
                  popularPackage!.location.name,
                  style: TextStyle(
                    fontSize: textSizeSmall,
                    color: isDarkMode
                        ? whiteColor.withAlpha(153)
                        : appTextColorPrimary.withAlpha(153),
                  ),
                ),
                4.height,
                if (popularPackage!.tag.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: appColorPrimary.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      popularPackage!.tag,
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
        _buildText(popularPackage?.location.name ?? 'Not specified'),
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
        _buildText('${popularPackage?.duration ?? 0} days'),
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
        _buildText(popularPackage?.hotels ?? 'To be confirmed'),
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
            'Price per person: $currency${popularPackage?.price ?? 0}',
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

  // Event Handlers
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
      // Max 10 travelers
      setState(() {
        travelerCount++;
      });
      _validateFormData();
    }
  }

  void _decrementTravelers() {
    if (travelerCount > 1) {
      // Min 1 traveler
      setState(() {
        travelerCount--;
      });
      _validateFormData();
    }
  }

  void _validateFormData() {
    if (popularPackage != null && selectedStartDate != null) {
      controller.validateForm(
        package: popularPackage!,
        startDate: selectedStartDate!,
        travelers: travelerCount,
        phoneNumber: phoneController.text,
      );
    }
  }

  void _handleContinue() async {
    // Check if package data exists
    if (popularPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Package information is missing. Please go back and select a package.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if start date is selected
    if (selectedStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a start date'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check authentication
    if (!authController.isValidSession) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to create a booking'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      // Clear any previous errors
      controller.clearFormErrors();

      // Create booking via API
      final result = await controller.createBooking(
        package: popularPackage!,
        startDate: selectedStartDate!,
        travelers: travelerCount,
        phoneNumber: phoneController.text,
        nationality: nationalityController.text.isEmpty
            ? null
            : nationalityController.text,
        remarks: remarksController.text.isEmpty ? null : remarksController.text,
        agreedToTerms: true,
      );

      if (result != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Booking created successfully! ID: ${controller.lastCreatedBookingId.value}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );

        // Navigate to payment screen or booking confirmation screen
        final bookingData = {
          'package': popularPackage,
          'startDate': selectedStartDate,
          'travelerCount': travelerCount,
          'phoneNumber': phoneController.text,
          'nationality': nationalityController.text,
          'remarks': remarksController.text,
          'totalPrice': totalPrice,
          'currency': currency,
          'bookingId': controller.lastCreatedBookingId.value,
          'bookingResponse': result,
        };

        // Navigate to payment screen with booking data
        Get.put(PaymentController());
        Get.toNamed(MyRoutes.paymentScreen, arguments: bookingData);
      }
    } catch (e) {
      // Error is already handled by the controller and shown in UI
      // Additional handling can be done here if needed
      print('❌ Booking creation failed: $e');

      // Show additional error context if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to create booking: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
