import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../widgets/app_widget.dart';
import '../../controller/theme_controller.dart';
import '../../model/booking.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  BookingDetailScreenState createState() => BookingDetailScreenState();
}

class BookingDetailScreenState extends State<BookingDetailScreen> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    final ThemeController themeController = Get.find<ThemeController>();
    isDarkMode = themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? appDarkBgColor : Colors.white,
      appBar: commonAppBarWidget(context, titleText: "Booking Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Header Card
              _buildHeaderCard(),
              20.height,
              
              // Status Timeline
              _buildStatusTimeline(),
              24.height,
              
              // Booking Information
              _buildSectionTitle("Booking Information"),
              12.height,
              _buildInfoCard(),
              24.height,
              
              // Traveler Information
              _buildSectionTitle("Traveler Information"),
              12.height,
              _buildTravelerCard(),
              24.height,
              
              // Payment Information
              _buildSectionTitle("Payment Information"),
              12.height,
              _buildPaymentCard(),
              24.height,
              
              // Action Buttons
              _buildActionButtons(),
              40.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appColorPrimary, appColorPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColorPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.booking.packageName,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildStatusChip(),
            ],
          ),
          16.height,
          Row(
            children: [
              Icon(Icons.confirmation_number, color: Colors.white70, size: 20),
              8.width,
              Expanded(
                child: Text(
                  'Booking ID: ${widget.booking.id}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _copyToClipboard(widget.booking.id),
                child: Icon(Icons.copy, color: Colors.white70, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? appDarkBgColor : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Timeline",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          16.height,
          _buildTimelineItem(
            "Booking Created",
            widget.booking.formattedCreatedDate,
            Icons.event,
            true,
          ),
          _buildTimelineItem(
            "Payment ${widget.booking.paymentStatus.toLowerCase() == 'paid' ? 'Completed' : 'Pending'}",
            widget.booking.paymentStatus.toLowerCase() == 'paid' ? "Completed" : "Pending",
            Icons.payment,
            widget.booking.paymentStatus.toLowerCase() == 'paid',
          ),
          _buildTimelineItem(
            "Travel Date",
            widget.booking.formattedTravelDate,
            Icons.flight_takeoff,
            false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, IconData icon, bool isCompleted, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isCompleted ? Icons.check : icon,
                color: isCompleted ? Colors.white : Colors.grey.shade600,
                size: 18,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        16.width,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                2.height,
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
                if (!isLast) 12.height,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? appDarkBgColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow("Travel Date", widget.booking.formattedTravelDate, Icons.calendar_today),
          16.height,
          _buildInfoRow("Number of Travelers", "${widget.booking.travelers}", Icons.people),
          16.height,
          _buildInfoRow("Booking Date", widget.booking.formattedCreatedDate, Icons.event),
          16.height,
          _buildInfoRow("Status", widget.booking.status, Icons.info),
        ],
      ),
    );
  }

  Widget _buildTravelerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? appDarkBgColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow("Guest Name", widget.booking.guestName, Icons.person),
          16.height,
          _buildInfoRow("Email", widget.booking.guestEmail, Icons.email),
          16.height,
          _buildInfoRow("Total Travelers", "${widget.booking.travelers} ${widget.booking.travelers == 1 ? 'Person' : 'People'}", Icons.group),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? appDarkBgColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow("Payment Status", widget.booking.paymentStatus.toUpperCase(), Icons.payment),
          16.height,
          if (widget.booking.totalAmountPaid > 0) ...[
            _buildInfoRow(
              "Amount Paid", 
              "${widget.booking.currency ?? '\$'}${widget.booking.totalAmountPaid.toStringAsFixed(2)}", 
              Icons.attach_money
            ),
            16.height,
          ],
          _buildInfoRow("Currency", widget.booking.currency ?? "USD", Icons.monetization_on),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary Action Button
        Container(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _handlePrimaryAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: appColorPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              _getPrimaryActionText(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        12.height,
        
        // Secondary Action Buttons Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _shareBooking(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: appColorPrimary,
                  side: BorderSide(color: appColorPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share, size: 18),
                    6.width,
                    Text(
                      "Share",
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            12.width,
            Expanded(
              child: OutlinedButton(
                onPressed: () => _downloadReceipt(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: appColorPrimary,
                  side: BorderSide(color: appColorPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, size: 18),
                    6.width,
                    Text(
                      "Receipt",
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Cancel Button (only for pending/confirmed bookings)
        // if (widget.booking.status.toLowerCase() != 'cancelled') ...[
        //   16.height,
        //   Container(
        //     width: double.infinity,
        //     height: 45,
        //     child: OutlinedButton(
        //       onPressed: () => _showCancelDialog(),
        //       style: OutlinedButton.styleFrom(
        //         foregroundColor: Colors.red,
        //         side: BorderSide(color: Colors.red.shade300),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //       ),
        //       child: Text(
        //         "Cancel Booking",
        //         style: GoogleFonts.inter(
        //           fontWeight: FontWeight.w500,
        //           color: Colors.red,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appColorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: appColorPrimary, size: 20),
        ),
        16.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              2.height,
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    
    switch (widget.booking.status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.white;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.white;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.booking.status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _getPrimaryActionText() {
    switch (widget.booking.status.toLowerCase()) {
      case 'pending':
        return widget.booking.paymentStatus.toLowerCase() == 'pending' 
            ? 'Complete Payment' 
            : 'View Details';
      // case 'confirmed':
      //   return 'View Itinerary';
      case 'cancelled':
        return 'Book Again';
      default:
        return 'View Details';
    }
  }

  void _handlePrimaryAction() {
    switch (widget.booking.status.toLowerCase()) {
      case 'pending':
        if (widget.booking.paymentStatus.toLowerCase() == 'pending') {
          _navigateToPayment();
        } else {
          _showDetailsDialog();
        }
        break;
      case 'confirmed':
        _showItineraryDialog();
        break;
      case 'cancelled':
        _bookAgain();
        break;
      default:
        _showDetailsDialog();
    }
  }

  void _navigateToPayment() {
    // Navigate to payment screen
    Get.snackbar(
      "Payment",
      "Redirecting to payment...",
      backgroundColor: appColorPrimary,
      colorText: Colors.white,
    );
  }

  void _showDetailsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Booking Details"),
        content: Text("Additional booking details would be shown here."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showItineraryDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Travel Itinerary"),
        content: Text("Your travel itinerary for ${widget.booking.packageName} would be displayed here."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _bookAgain() {
    Get.snackbar(
      "Book Again",
      "Redirecting to booking page...",
      backgroundColor: appColorPrimary,
      colorText: Colors.white,
    );
  }

  void _shareBooking() {
    Get.snackbar(
      "Share",
      "Booking details copied to clipboard",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _downloadReceipt() {
    Get.snackbar(
      "Download",
      "Receipt download started...",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showCancelDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Cancel Booking"),
        content: Text("Are you sure you want to cancel this booking? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _cancelBooking();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }

  void _cancelBooking() {
    Get.snackbar(
      "Booking Cancelled",
      "Your booking has been cancelled successfully",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Copied",
      "Booking ID copied to clipboard",
      backgroundColor: appColorPrimary,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
}