import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/strings.dart';
import '../../../route/my_route.dart';
import '../../../theme/styles.dart';
import '../../controller/seat_booking_controller.dart';
import '../../model/seat.dart';
import '../../model/ticket.dart';
import '../popular_package/ticket_view.dart';
import 'custom_row_text.dart';

class SeatBookingScreen extends StatefulWidget {
  final Ticket ticket;

  const SeatBookingScreen({super.key, required this.ticket});

  @override
  SeatBookingScreenState createState() => SeatBookingScreenState();
}

class SeatBookingScreenState extends State<SeatBookingScreen> {
  late SeatBookingController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SeatBookingController());
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = controller.themeController.isDarkMode;

    return GetBuilder<SeatBookingController>(
        init: controller,
        tag: 'travel_seat-booking',
        // theme: theme,
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar:  Container(
                height: 70,
                color: isDarkMode ? appColorDarkPrimary : Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                child:  GradientElevatedButton(
                  onPressed: () {
                    List<String> selectedSeatNumbers =
                    controller.getSelectedSeats();
                    // print('Selected Seats: $selectedSeatNumbers');

                    if (selectedSeatNumbers.isNotEmpty) {
                      Get.toNamed(MyRoutes.confirmationScreen);
                    } else {
                      Fluttertoast.showToast(msg: seatErrMsg);
                    }
                    // You can handle the selected seat numbers here
                  },
                  text: continueText,
                ),
              ),
              backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
              appBar: commonAppBarWidget(context, titleText: selectYourSeat),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TicketView(
                      ticket: widget.ticket,
                      isDarkMode: isDarkMode,
                      rightMargin: 0,
                      onPressed: () {
                        Get.off(SeatBookingScreen(
                          ticket: widget.ticket,
                        ));
                      },
                    ),
                    20.height,
                    const Text(
                      economyClass,
                      style: TextStyle(
                          fontSize: textSizeLargeMedium,
                          fontWeight: FontWeight.bold),
                    ),
                    20.height,
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomRowText(
                              text: available,
                              gradient: isDarkMode
                                  ? availableDarkColor
                                  : availableColor),
                          const CustomRowText(
                              text: selected, gradient: selectedColor),
                          CustomRowText(
                              text: unavailable,
                              gradient: unavailableColor)
                        ],
                      ),
                    ),
                    20.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Obx(() {
                        return controller.myData.isEmpty
                            ? const Text(noDataAvailable)
                            : GridView.builder(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 30.0,
                            mainAxisSpacing: 30.0,
                          ),
                          itemCount: controller.myData.length,
                          // padding: EdgeInsets.all(16.0),
                          itemBuilder: (context, index) {
                            Seat seat = controller.myData[index];
                            return Obx(() => InkWell(
                              onTap: () {
                                if(seat.bookingStatus == true) {
                                  controller
                                      .toggleSeatSelection(
                                      index);
                                }
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: seat
                                      .isSelected.value
                                      ? selectedColor
                                      : (seat.bookingStatus!
                                      ? isDarkMode
                                      ? availableDarkColor
                                      : availableColor
                                      : unavailableColor),
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                  border: Border.all(
                                      color:
                                      appTextColorPrimary
                                          .withAlpha(
                                          128),
                                      width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    seat.seatNumber
                                        .toString(),
                                    style: TextStyle(
                                      color: seat.isSelected
                                          .value
                                          ? Colors.white
                                          : isDarkMode
                                          ? Styles
                                          .whiteColor
                                          : appTextColorPrimary,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          },
                        );
                      },),
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
          );
        });
  }
}
