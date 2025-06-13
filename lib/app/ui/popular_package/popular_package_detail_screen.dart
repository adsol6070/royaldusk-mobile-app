import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_images.dart';
import '../../../route/my_route.dart';
import '../../controller/popular_package_detail_controller.dart';
import '../../model/popular_packages.dart';
import 'custom_review_rating_view.dart';

class PopularPackageDetailScreen extends StatefulWidget {
  final PopularPackage popularPackage;

  const PopularPackageDetailScreen({Key? key, required this.popularPackage})
      : super(key: key);

  @override
  PopularPackageDetailScreenState createState() =>
      PopularPackageDetailScreenState();
}

class PopularPackageDetailScreenState
    extends State<PopularPackageDetailScreen> {
  late PopularPackageDetailController controller;
  late bool isDarkMode;

  // Enhanced color scheme
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color accentTeal = Color(0xFF00BCD4);
  static const Color softGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF6C757D);
  static const Color darkGray = Color(0xFF343A40);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Dynamic colors based on theme
  Color get backgroundColor => isDarkMode ? appDarkBgColor : Colors.white;
  Color get cardBackgroundColor => isDarkMode ? appDarkBgColor : Colors.white;
  Color get textPrimaryColor => isDarkMode ? whiteColor : darkGray;
  Color get textSecondaryColor =>
      isDarkMode ? whiteColor.withAlpha(153) : mediumGray;
  Color get surfaceColor =>
      isDarkMode ? appTextColorPrimary.withAlpha(26) : softGray;
  Color get borderColor =>
      isDarkMode ? whiteColor.withAlpha(26) : Colors.black.withAlpha(26);
  Color get primaryColor => appColorPrimary;
  Color get shadowColor =>
      isDarkMode ? Colors.black.withAlpha(77) : Colors.black.withAlpha(26);

  @override
  void initState() {
    super.initState();
    controller = PopularPackageDetailController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularPackageDetailController>(
        init: controller,
        tag: 'travel_popular_packages_detail',
        builder: (controller) {
          return Material(
            child: Stack(
              children: <Widget>[
                // Hero Image with Gradient Overlay
                Container(
                  height: context.w / 1,
                  child: Stack(
                    children: [
                      commonCacheImageWidget(
                        widget.popularPackage.imageUrl,
                        context.w / 1,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay for better text readability
                      Container(
                        height: context.w / 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Container with improved design
                Padding(
                  padding: EdgeInsets.only(top: context.w * 0.25),
                  child: Container(
                    height: context.h - 140,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: context.w / 2),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Package Header
                              _buildPackageHeader(),
                              16.height,

                              // Quick Info Cards
                              _buildQuickInfoCards(),
                              24.height,

                              // Rating and Availability Row
                              _buildRatingAvailabilityRow(),
                              32.height,

                              // About Trip Section
                              _buildAboutTripSection(),
                              32.height,

                              // Features Section
                              _buildFeaturesSection(),
                              32.height,

                              // What's Included Section
                              _buildInclusionsSection(),
                              32.height,

                              // What's Excluded Section
                              _buildExclusionsSection(),
                              32.height,

                              // Itinerary Section
                              _buildItinerarySection(),
                              32.height,

                              // Important Information Section
                              _buildImportantInfoSection(),
                              32.height,

                              // Policy Section
                              _buildPolicySection(),
                              100.height,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Back Button
                _buildBackButton(context),

                // Bottom Book Now Button
                _buildBottomBookButton(),
              ],
            ),
          );
        });
  }

  Widget _buildPackageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.popularPackage.name,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                      height: 1.2,
                    ),
                  ),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryColor, size: 20),
                      6.width,
                      Expanded(
                        child: Text(
                          widget.popularPackage.location.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.popularPackage.tag.isNotEmpty) ...[
                    12.height,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.popularPackage.tag,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? appTextColorPrimary.withAlpha(26)
                        : lightBlue,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor.withOpacity(0.2)),
                  ),
                  child: SvgPicture.asset(
                    bookmarkOnlyIcon,
                    width: 20,
                    height: 20,
                    colorFilter:
                        ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  ),
                ).onTap(() {}),
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${widget.popularPackage.currency} ${widget.popularPackage.price}",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      "per person",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.schedule_outlined,
            title: "Duration",
            value: "${widget.popularPackage.duration} days",
            color: accentTeal,
          ),
        ),
        16.width,
        Expanded(
          child: _buildInfoCard(
            icon: Icons.hotel_outlined,
            title: "Hotels",
            value: widget.popularPackage.hotels,
            color: warningOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          12.height,
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          4.height,
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingAvailabilityRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [appTextColorPrimary.withAlpha(26), appDarkBgColor]
              : [softGray, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rating section
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CustomReviewRatingViewScreen(
                  reviewCount: widget.popularPackage.review,
                  rating: 4.7,
                ),
                12.width,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: successGreen, size: 16),
                      4.width,
                      Text(
                        "5.0",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          12.width,
          // Check availability button
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     height: 45,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         CheckAvailabilityBottomSheet.show(context, isDarkMode);
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: primaryColor,
          //         foregroundColor: Colors.white,
          //         elevation: 0,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //       child: Text(
          //         "Check Availability",
          //         style: GoogleFonts.inter(
          //           fontSize: 12,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          12.width,
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTripSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("About Trip", Icons.info_outline, primaryColor),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode
                ? appTextColorPrimary.withAlpha(26)
                : primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
          ),
          child: Text(
            widget.popularPackage.description,
            style: GoogleFonts.inter(
              color: textPrimaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    if (widget.popularPackage.features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Features", Icons.star_outline, accentTeal),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: accentTeal.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentTeal.withOpacity(0.1)),
          ),
          child: Column(
            children: widget.popularPackage.features
                .map((feature) => _buildFeatureItem(feature.name, primaryColor))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check, color: color, size: 16),
          ),
          12.width,
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInclusionsSection() {
    if (widget.popularPackage.inclusions.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            "What's Included", Icons.add_circle_outline, successGreen),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: successGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: successGreen.withOpacity(0.1)),
          ),
          child: Column(
            children: widget.popularPackage.inclusions
                .map((inclusion) =>
                    _buildFeatureItem(inclusion.name, successGreen))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExclusionsSection() {
    if (widget.popularPackage.exclusions.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            "What's Excluded", Icons.remove_circle_outline, errorRed),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: errorRed.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: errorRed.withOpacity(0.1)),
          ),
          child: Column(
            children: widget.popularPackage.exclusions
                .map((exclusion) => _buildExclusionItem(exclusion.name))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExclusionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.close, color: errorRed, size: 16),
          ),
          12.width,
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItinerarySection() {
    if (widget.popularPackage.itineraries.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            "Day-by-Day Itinerary", Icons.map_outlined, warningOrange),
        ...widget.popularPackage.itineraries.asMap().entries.map((entry) {
          int index = entry.key;
          ItineraryItem item = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: warningOrange.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            warningOrange,
                            warningOrange.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: warningOrange.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    16.width,
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                16.height,
                Text(
                  item.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: textSecondaryColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildImportantInfoSection() {
    if (widget.popularPackage.importantInfo.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Important Information",
            Icons.warning_amber_outlined, warningOrange),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: warningOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: warningOrange.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: warningOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.info, color: warningOrange, size: 20),
              ),
              16.width,
              Expanded(
                child: Text(
                  widget.popularPackage.importantInfo,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: textPrimaryColor,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPolicySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            "Policies & Terms", Icons.policy_outlined, mediumGray),
        _buildPolicyItem("Booking Policy",
            widget.popularPackage.policy.bookingPolicy, Icons.book_outlined),
        _buildPolicyItem(
            "Cancellation Policy",
            widget.popularPackage.policy.cancellationPolicy,
            Icons.cancel_outlined),
        _buildPolicyItem("Payment Terms",
            widget.popularPackage.policy.paymentTerms, Icons.payment_outlined),
        _buildPolicyItem("Visa Details",
            widget.popularPackage.policy.visaDetail, Icons.assignment_outlined),
      ],
    );
  }

  Widget _buildPolicyItem(String title, String content, IconData icon) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              12.width,
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          16.height,
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      height: context.h * 0.2,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, left: 20),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => finish(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: darkGray,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBookButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(MyRoutes.confirmationScreen,
                  arguments: widget.popularPackage);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              "Book Now",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
