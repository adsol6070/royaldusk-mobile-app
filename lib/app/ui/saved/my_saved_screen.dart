import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/strings.dart';
import '../../controller/my_saved_list_controller.dart';
import '../../model/category.dart';
import '../../model/hotels.dart';
import '../../model/places.dart';
import '../../model/popular_packages.dart';
import '../../model/ticket.dart';
import '../flight/seat_booking_screen.dart';
import '../hotel/popular_hotel_view.dart';
import '../my_app_bar.dart';
import '../place/popular_place_view.dart';
import '../popular_package/ticket_view.dart';
import '../trip/trip_category_view.dart';
import '../trip/trip_list_view.dart';

class MySavedScreen extends StatefulWidget {
  const MySavedScreen({super.key});

  @override
  MySavedScreenState createState() => MySavedScreenState();
}

class MySavedScreenState extends State<MySavedScreen> {
  late MySavedController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MySavedController());
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MySavedController>(
        init: controller,
        tag: 'travel_my_save',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: MyAppBar(
              /*  controller: controller,*/ isDarkMode: isDarkMode,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryList(),
                    20.height,
                    const Text(
                      "Result found (04)",
                      style: TextStyle(
                          fontSize: textSizeMedium, fontWeight: FontWeight.w500),
                    ),
                    // 10.height,
                    if (controller.selectedIndex == 0)
                      Expanded(
                        child: Center(
                            child: FutureBuilder<List<PopularPackage>>(
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
                                () => controller.myTripList.isEmpty
                                    ? const Text(noDataAvailable)
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.myTripList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return TripListView(
                                              controller.myTripList[index]);
                                        },
                                      ),
                              );
                            }
                          },
                        )),
                      ),
                    if (controller.selectedIndex == 1)
                      Expanded(
                        child: Center(
                            child: FutureBuilder<List<Ticket>>(
                          future: controller.fetchFlightData(),
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
                                () => controller.myFlightList.isEmpty
                                    ? const Text(noDataAvailable)
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.myFlightList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          Ticket singleTicket =
                                              controller.myFlightList[index];
                                          return TicketView(
                                            rightMargin: 0,
                                            isColor: true,
                                            ticket: singleTicket,
                                            isDarkMode: false, onPressed: () {Get.off( SeatBookingScreen(ticket: singleTicket,));  },
                                          );
                                        }),
                              );
                            }
                          },
                        )),
                      ),
                    if (controller.selectedIndex == 2)
                      Expanded(
                        child: Center(
                            child: FutureBuilder<List<Places>>(
                          future: controller.fetchPlacesData(),
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
                                () => controller.myPlacesList.isEmpty
                                    ? const Text(noDataAvailable)
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.myPlacesList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          Places place =
                                              controller.myPlacesList[index];
                                          return PopularPlaceView(place);
                                        },
                                      ),
                              );
                            }
                          },
                        )),
                      ),
              
                    if (controller.selectedIndex == 3)
                      Expanded(
                        child: Center(
                            child: FutureBuilder<List<Hotel>>(
                          future: controller.fetchHotelData(),
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
                                () => controller.myHotelList.isEmpty
                                    ? const Text(noDataAvailable)
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.myHotelList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          Hotel hotel =
                                              controller.myHotelList[index];
                                          return PopularHotelView(
                                            hotel,
                                            isBooked: false,
                                          );
                                        },
                                      ),
                              );
                            }
                          },
                        )),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _buildCategoryList() {
    return Obx(
      () => Center(
        child: HorizontalList(
          itemCount: controller.allCategories.length,
          itemBuilder: (ctx, i) {
            Category cat = controller.allCategories[i];
            // controller.allCategories[0].isSelected = true;
            return TripCategoryViewScreen(
              selectedIndex: controller.selectedIndex,
              index: i,
              category: cat,
              isDarkMode: isDarkMode,
              onPressed: () {
                controller.toggleSelection(i);
              },
            );
          },
        ),
      ),
    );
  }
}
