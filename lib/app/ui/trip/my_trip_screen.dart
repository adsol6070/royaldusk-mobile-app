import 'package:royaldusk_mobile_app/app/ui/trip/trip_category_view.dart';
import 'package:royaldusk_mobile_app/app/ui/trip/trip_flight_ticket_view.dart';
import 'package:royaldusk_mobile_app/app/ui/trip/booking_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/strings.dart';
import '../../controller/my_trip_controller.dart';
import '../../model/category.dart';
import '../../model/hotels.dart';
import '../../model/booking.dart';
import '../../model/ticket.dart';
import '../../../route/my_route.dart';
import '../hotel/popular_hotel_view.dart';
import '../my_app_bar.dart';

class MyTripScreen extends StatefulWidget {
  const MyTripScreen({super.key});

  @override
  MyTripScreenState createState() => MyTripScreenState();
}

class MyTripScreenState extends State<MyTripScreen> {
  late MyTripController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyTripController());
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyTripController>(
        init: controller,
        tag: 'travel_my_trip',
        builder: (controller) {
          return Scaffold(
            backgroundColor: isDarkMode ? appDarkBgColor : Colors.white,
            appBar: MyAppBar(
              isDarkMode: isDarkMode,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryList(),
                  20.height,

                  // Results counter
                  Obx(() => Text(
                        _getResultText(),
                        style: const TextStyle(
                            fontSize: textSizeMedium,
                            fontWeight: FontWeight.w500),
                      )),

                  // My Bookings Tab
                  if (controller.selectedIndex == 0)
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.fetchBookingsData(),
                        child: Obx(() {
                          // Show loading indicator when loading and haven't loaded initially
                          if (controller.isLoadingBookings.value &&
                              !controller.hasInitiallyLoaded.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: appColorPrimary,
                              ),
                            );
                          }

                          // Show error state only for actual network/server errors
                          if (controller.bookingsError.value.isNotEmpty &&
                              controller.myBookingsList.isEmpty &&
                              controller.hasInitiallyLoaded.value) {
                            return _buildErrorState(
                                controller.bookingsError.value);
                          }

                          // Show empty state when no bookings but initial load is complete
                          if (controller.myBookingsList.isEmpty &&
                              controller.hasInitiallyLoaded.value) {
                            return _buildEmptyState("No bookings found",
                                "You haven't made any bookings yet.");
                          }

                          // Show bookings list
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.myBookingsList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return BookingListView(
                                booking: controller.myBookingsList[index],
                                isDarkMode: isDarkMode,
                              );
                            },
                          );
                        }),
                      ),
                    ),

                  // Flights Tab
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
                                  ? _buildEmptyState("No flights found",
                                      "You don't have any flight bookings.")
                                  : ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.myFlightList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        Ticket singleTicket =
                                            controller.myFlightList[index];
                                        return TripFlightTicketView(
                                          rightMargin: 0,
                                          isColor: true,
                                          ticket: singleTicket,
                                          isDarkMode: isDarkMode,
                                        );
                                      }),
                            );
                          }
                        },
                      )),
                    ),

                  // Hotels Tab
                  if (controller.selectedIndex == 2)
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
                                  ? _buildEmptyState("No hotels found",
                                      "You don't have any hotel bookings.")
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
                                          isBooked: true,
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
          );
        });
  }

  Widget _buildErrorState(String errorMessage) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: isDarkMode ? Colors.white54 : Colors.black54,
              ),
              16.height,
              Text(
                'Error loading bookings',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              8.height,
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              16.height,
              ElevatedButton(
                onPressed: () {
                  controller.fetchBookingsData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColorPrimary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 80,
                color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
              ),
              16.height,
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              8.height,
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              24.height,
              ElevatedButton(
                onPressed: () {
                  Get.offNamedUntil(
                    MyRoutes.mainDrawerScreen,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColorPrimary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Explore Packages',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getResultText() {
    switch (controller.selectedIndex) {
      case 0:
        int count = controller.myBookingsList.length;
        return "Bookings found ($count)";
      case 1:
        int count = controller.myFlightList.length;
        return "Flights found ($count)";
      case 2:
        int count = controller.myHotelList.length;
        return "Hotels found ($count)";
      default:
        return "Results found (0)";
    }
  }

  Widget _buildCategoryList() {
    return Obx(
      () => Center(
        child: HorizontalList(
          itemCount: controller.allCategories.length,
          itemBuilder: (ctx, i) {
            Category cat = controller.allCategories[i];
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
