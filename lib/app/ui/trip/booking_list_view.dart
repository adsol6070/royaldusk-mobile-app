import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../model/booking.dart';
import 'booking_detail_screen.dart';

class BookingListView extends StatelessWidget {
  final Booking booking;
  final bool isDarkMode;

  const BookingListView({
    Key? key,
    required this.booking,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BookingDetailScreen(booking: booking));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? appDarkBgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode 
                ? Colors.white.withOpacity(0.1) 
                : Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Package Name and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.packageName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  8.width,
                  _buildStatusChip(),
                ],
              ),
              12.height,
              
              // Booking ID
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  6.width,
                  Text(
                    'ID: ${booking.id.substring(0, 8)}...',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              8.height,
              
              // Travel Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: appColorPrimary,
                  ),
                  6.width,
                  Text(
                    'Travel Date: ${booking.formattedTravelDate}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              8.height,
              
              // Travelers Count
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: appColorPrimary,
                  ),
                  6.width,
                  Text(
                    '${booking.travelers} ${booking.travelers == 1 ? 'Traveler' : 'Travelers'}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              12.height,
              
              // Divider
              Divider(
                color: isDarkMode ? Colors.white24 : Colors.black12,
                height: 1,
              ),
              12.height,
              
              // Bottom Row with Payment Status and Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Payment Status
                  Row(
                    children: [
                      _buildPaymentStatusIcon(),
                      6.width,
                      Text(
                        booking.paymentStatus.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getPaymentStatusColor(),
                        ),
                      ),
                    ],
                  ),
                  
                  // Amount and Action
                  Row(
                    children: [
                      if (booking.totalAmountPaid > 0) ...[
                        Text(
                          '${booking.currency ?? '\$'}${booking.totalAmountPaid.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: appColorPrimary,
                          ),
                        ),
                        8.width,
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: appColorPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: appColorPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    
    switch (booking.status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        booking.status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusIcon() {
    IconData icon;
    Color color;
    
    switch (booking.paymentStatus.toLowerCase()) {
      case 'paid':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'pending':
        icon = Icons.schedule;
        color = Colors.orange;
        break;
      case 'failed':
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case 'refunded':
        icon = Icons.refresh;
        color = Colors.blue;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, size: 16, color: color);
  }

  Color _getPaymentStatusColor() {
    switch (booking.paymentStatus.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}