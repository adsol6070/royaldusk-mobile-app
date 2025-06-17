import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/custom_row_text_with_click.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
import '../../../route/my_route.dart';
import '../../controller/confirmation_controller.dart';
import '../../model/popular_packages.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  ConfirmationScreenState createState() => ConfirmationScreenState();
}

class ConfirmationScreenState extends State<ConfirmationScreen> {
  late ConfirmationController controller;
  late bool isDarkMode;

  // Get package from arguments passed via Get.toNamed
  PopularPackage? get popularPackage => Get.arguments as PopularPackage?;

  // Form controllers
  final TextEditingController phoneController = TextEditingController();
  DateTime? selectedStartDate;
  int travelerCount = 1;

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = ConfirmationController();
    isDarkMode = controller.themeController.isDarkMode;

    // Set initial values if package is provided
    if (popularPackage != null) {
      travelerCount = 1; // Default to 1 person
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
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

                        // Continue Button
                        GradientElevatedButton(
                            onPressed: _handleContinue,
                            text: "Continue to Payment"),

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
                color: isDarkMode
                    ? whiteColor.withAlpha(51)
                    : appTextColorPrimary.withAlpha(51),
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
    }
  }

  void _incrementTravelers() {
    if (travelerCount < 10) {
      // Max 10 travelers
      setState(() {
        travelerCount++;
      });
    }
  }

  void _decrementTravelers() {
    if (travelerCount > 1) {
      // Min 1 traveler
      setState(() {
        travelerCount--;
      });
    }
  }

  void _handleContinue() {
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

    if (_formKey.currentState!.validate()) {
      // Check if start date is selected
      if (selectedStartDate == null) {
        // Show error for date selection
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a start date'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Create booking data object to pass to payment screen
      final bookingData = {
        'package': popularPackage,
        'startDate': selectedStartDate,
        'travelerCount': travelerCount,
        'phoneNumber': phoneController.text,
        'totalPrice': totalPrice,
        'currency': currency,
      };

      // Navigate to payment screen with booking data
      Get.toNamed(MyRoutes.paymentScreen, arguments: bookingData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking details confirmed!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
