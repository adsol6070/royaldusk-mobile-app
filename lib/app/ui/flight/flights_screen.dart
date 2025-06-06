import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:royaldusk_mobile_app/app/ui/flight/search_flight_screen.dart';
import 'package:royaldusk_mobile_app/app/ui/flight/seat_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';


import '../../../constant/app_colors.dart';
import '../../../constant/strings.dart';
import '../../controller/flight_controller.dart';
import '../../model/ticket.dart';
import '../popular_package/ticket_view.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  FlightScreenState createState() => FlightScreenState();
}

class FlightScreenState extends State<FlightScreen> {
  late FlightController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FlightController());
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlightController>(
        init: controller,
        tag: 'travel_flight',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
            appBar: commonAppBarWidget(context,
                titleText: flights,
                actionWidget: IconButton(
                    onPressed: () {
                      Get.to(const SearchFlightScreen());
                    },
                    icon: SvgPicture.asset(searchIcon,
                        colorFilter: ColorFilter.mode(
                            isDarkMode ? whiteColor : appTextColorPrimary,
                            BlendMode.srcIn)))),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateView(),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 0.9],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            gradientBgColor1,
                            gradientBgColor2,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                      ),
                      margin: const EdgeInsets.only(top: 30),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    sortBy,
                                    style: TextStyle(
                                        fontSize: textSizeSMedium,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  10.width,
                                  _buildSortBydDropDown(),
                                  70.width,
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            whiteColor.withAlpha(51),
                                        child: SvgPicture.asset(filterIcon),
                                      ))
                                ],
                              ),
                              10.height,
                              Text(
                                flightAvailable,
                                style: TextStyle(
                                    color: Colors.white.withAlpha(230),
                                    fontSize: textSizeMedium,
                                    fontWeight: FontWeight.w400),
                              ),
                              20.height,
                              Center(
                                  child: FutureBuilder<List<Ticket>>(
                                future: controller.fetchData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(
                                      color: appColorPrimary,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Obx(
                                      () => controller.myData.isEmpty
                                          ? const Text(noDataAvailable)
                                          : ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  controller.myData.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                Ticket singleTicket =
                                                    controller.myData[index];
                                                return TicketView(
                                                  rightMargin: 0,
                                                  isColor: true,
                                                  ticket: singleTicket,
                                                  isDarkMode: false,
                                                  onPressed: () {
                                                    Get.to(SeatBookingScreen(
                                                      ticket: singleTicket,
                                                    ));
                                                  },
                                                );
                                              }),
                                    );
                                  }
                                },
                              )),
                              20.height,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildSortBydDropDown() {
    return Expanded(
      child: Container(
        // width: 150,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: whiteColor.withAlpha(51)
            // border: Border.all(color: Colors.grey),
            ),
        child: Obx(
          () => DropdownButton<String>(
            iconEnabledColor: Colors.white,
            icon: SvgPicture.asset(
              arrowDownIcon,
              height: 20,
              width: 20,
            ),
            value: controller.selectedValue.value.isNotEmpty
                ? controller.selectedValue.value
                : null,
            onChanged: (value) {
              controller.onValueChanged(value!);
            },
            items: [
              'Price',
              'Discount',
              'Low To High',
              'High To Low',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      color: isDarkMode ? whiteColor : appTextColorPrimary),
                ),
              );
            }).toList(),
            isExpanded: true,
            underline: const SizedBox(),
            style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontSize: textSizeSMedium,
                color: whiteColor), // Removes the default underline
          ),
        ),
      ),
    );
  }

  _buildDateView() {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        controller.onDateSelected(selectedDate);
      },
      activeColor: checkGreenColor,
      headerProps: const EasyHeaderProps(showHeader: false),
      dayProps: EasyDayProps(
        height: 56.0,
        width: 56.0,
        borderColor: isDarkMode
            ? whiteColor.withAlpha(26)
            : appTextColorPrimary.withAlpha(26),
        dayStructure: DayStructure.dayStrDayNum,
        inactiveDayStyle: DayStyle(
          dayStrStyle: TextStyle(
            color: isDarkMode ? whiteColor : appTextColorPrimary,
            fontSize: textSizeSmall,
            fontWeight: FontWeight.w500,
          ),
          dayNumStyle: TextStyle(
            fontSize: textSizeLargeMedium,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? whiteColor : appTextColorPrimary,
          ),
        ),
        activeDayStyle: const DayStyle(
          dayStrStyle: TextStyle(
            color: whiteColor,
            fontSize: textSizeSmall,
            fontWeight: FontWeight.w500,
          ),
          dayNumStyle: TextStyle(
              fontSize: textSizeLargeMedium,
              fontWeight: FontWeight.bold,
              color: whiteColor),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: checkGreenColor),
        ),
      ),
    );
  }
}
