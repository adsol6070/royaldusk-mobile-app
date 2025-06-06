import 'package:royaldusk_mobile_app/app/ui/flight/seat_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/strings.dart';
import '../../controller/select_file_controller.dart';
import '../../model/ticket.dart';
import '../popular_package/ticket_view.dart';

class SelectFlightScreen extends StatefulWidget {
  const SelectFlightScreen({super.key});

  @override
  SelectFlightScreenState createState() => SelectFlightScreenState();
}

class SelectFlightScreenState extends State<SelectFlightScreen> {
  late SelectFlightController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SelectFlightController());
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectFlightController>(
      builder: (SelectFlightController controller) {
        return Scaffold(
                  backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                  appBar: commonAppBarWidget(context, titleText: selectFlight),
                  body: SafeArea(
                    child: FutureBuilder<List<Ticket>>(
                            future: controller.fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: appColorPrimary,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Obx(
                                  () => controller.myData.isEmpty
                    ? const Text(noDataAvailable)
                    : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.myData.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            Ticket singleTicket = controller.myData[index];
                            return TicketView(
                              rightMargin: 0,
                              isColor: true,
                              ticket: singleTicket,
                              isDarkMode: isDarkMode, onPressed: () {Get.off( SeatBookingScreen(ticket: singleTicket,));  },
                            );
                          }),
                    ),
                                );
                              }
                            },
                    ),
                  ),
                );
      },
    );
  }
}
