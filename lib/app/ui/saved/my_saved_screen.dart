import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/app/model/package.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../controller/my_saved_list_controller.dart';
import '../../model/category.dart';
import '../../model/hotels.dart';
import '../../model/places.dart';
import '../../model/ticket.dart';
import '../flight/seat_booking_screen.dart';
import '../hotel/popular_hotel_view.dart';
import '../my_app_bar.dart';
import '../place/popular_place_view.dart';
import '../popular_package/ticket_view.dart';
import '../trip/trip_category_view.dart';
import '../trip/trip_list_view.dart';
import '../../../route/my_route.dart';

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

    // Refresh saved packages when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSavedPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MySavedController>(
        init: controller,
        tag: 'travel_my_save',
        builder: (controller) {
          return Scaffold(
            backgroundColor: isDarkMode ? appDarkBgColor : Colors.white,
            appBar: MyAppBar(
              isDarkMode: isDarkMode,
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

                    // Dynamic result count
                    Obx(() => Text(
                          controller.getResultText(),
                          style: const TextStyle(
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight.w500),
                        )),

                    // Packages Tab (Saved Packages)
                    if (controller.selectedIndex == 0)
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.loadSavedPackages();
                          },
                          child: Obx(() {
                            if (controller.isLoadingSavedPackages.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: appColorPrimary,
                                ),
                              );
                            }

                            if (controller.savedPackages.isEmpty) {
                              return _buildEmptyState(
                                "No saved packages yet",
                                "Start exploring and save your favorite travel packages!",
                                Icons.bookmark_border,
                              );
                            }

                            return ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.savedPackages.length,
                              itemBuilder: (context, index) {
                                Package package =
                                    controller.savedPackages[index];
                                return TripListView(package);
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
                                    ? _buildEmptyState(
                                        "No saved flights",
                                        "You haven't saved any flights yet.",
                                        Icons.flight,
                                      )
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount:
                                            controller.myFlightList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          Ticket singleTicket =
                                              controller.myFlightList[index];
                                          return TicketView(
                                            rightMargin: 0,
                                            isColor: true,
                                            ticket: singleTicket,
                                            isDarkMode: isDarkMode,
                                            onPressed: () {
                                              Get.off(SeatBookingScreen(
                                                ticket: singleTicket,
                                              ));
                                            },
                                          );
                                        }),
                              );
                            }
                          },
                        )),
                      ),

                    // Places Tab
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
                                    ? _buildEmptyState(
                                        "No saved places",
                                        "You haven't saved any places yet.",
                                        Icons.place,
                                      )
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount:
                                            controller.myPlacesList.length,
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

                    // Hotels Tab
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
                                    ? _buildEmptyState(
                                        "No saved hotels",
                                        "You haven't saved any hotels yet.",
                                        Icons.hotel,
                                      )
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount:
                                            controller.myHotelList.length,
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

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
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
                  // Navigate to browse packages screen
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
                  'Browse Packages',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCategoryList() {
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
