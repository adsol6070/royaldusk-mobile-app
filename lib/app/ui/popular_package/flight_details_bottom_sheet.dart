import 'package:royaldusk_mobile_app/app/ui/popular_package/ticket_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../model/ticket.dart';
import '../flight/seat_booking_screen.dart';

class FlightDetailsBottomSheet {

  static void show(BuildContext context, List<Ticket> ticketList, bool isDarkMode) {
    showModalBottomSheet(
      backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheetContent(ticketList,isDarkMode);
      },
    );
  }

  static Widget _buildBottomSheetContent(List<Ticket> ticketList, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:isDarkMode? appDarkBgColor: appTextColorPrimary.withAlpha(77),
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () { Get.back();  },
                icon: SvgPicture.asset(
                 isDarkMode ? closeSquareWhiteIcon: closeSquareIcon,
                  width: 25,
                  height: 25,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    flightDetails,
                    style: TextStyle(
                      fontSize: textSizeNormal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          20.height,
          Expanded(
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: ticketList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Ticket singleTicket = ticketList[index];
                  return  TicketView(isColor: true,
                    ticket: singleTicket, isDarkMode: isDarkMode, onPressed: () {Get.off( SeatBookingScreen(ticket: singleTicket,));  },
                  );
                }),
          ),
          // Add more widgets as needed
        ],
      ),
    );
  }
}
