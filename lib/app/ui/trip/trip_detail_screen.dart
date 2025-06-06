import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';


import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/custom_textview_with_icon.dart';
import '../../../widgets/grediant_button.dart';
import '../../controller/trip_detail_controller.dart';
import '../../model/popular_packages.dart';
import '../dashboard/category_view.dart';
import '../popular_package/custom_review_rating_view.dart';
import '../popular_package/flight_details_bottom_sheet.dart';
import '../popular_package/hotel_details_bottom_sheet.dart';

class TripDetailScreen extends StatefulWidget {
  final PopularPackage popularPackage;

  const TripDetailScreen({Key? key, required this.popularPackage})
      : super(key: key);

  @override
  TripDetailScreenState createState() => TripDetailScreenState();
}

class TripDetailScreenState extends State<TripDetailScreen> {
  late TripDetailController controller;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = TripDetailController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripDetailController>(
        init: controller,
        tag: 'travel_trip_detail',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                SizedBox(
                  height: context.w / 1,
                  child: commonCacheImageWidget(
                    widget.popularPackage.image,
                    context.w / 1,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  // physics: ScrollPhysics(),
                  padding: EdgeInsets.only(top: context.w * 0.25),
                  child: Container(
                    height: context.h - 140,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: isDarkMode ? appDarkBgColor : appLightBgColor),
                    margin: EdgeInsets.only(top: context.w / 2),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode
                                    ? appDarkBgColor
                                    : appTextColorPrimary.withAlpha(77),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      widget.popularPackage.name.toString(),
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: textSizeLarge),
                                    ),
                                  ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: isDarkMode
                                                ? Colors.white
                                                    .withAlpha(26)
                                                : appTextColorPrimary
                                                    .withAlpha(26)),
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                    child: SvgPicture.asset(
                                      bookmarkOnlyIcon,
                                    ),
                                  ).onTap(() {}),
                                ],
                              ),
                              10.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTextViewWithIcon(
                                        fontWeight: FontWeight.w500,
                                        fontSize: textSizeSMedium,
                                        text: widget.popularPackage.location
                                            .toString(),
                                        icon: mapIcon,
                                        isDarkMode: isDarkMode),
                                  ),
                                  8.width,
                                  CustomReviewRatingViewScreen(
                                      reviewList:
                                          widget.popularPackage.reviewList,
                                      ratting: widget.popularPackage.rating),
                                  8.width,
                                  Row(children: [
                                    SvgPicture.asset(
                                      starIcon,
                                      height: 20,
                                      width: 20,
                                    ),
                                    2.width,
                                    Text(
                                      widget.popularPackage.rating.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: textSizeMedium),
                                    ),
                                  ]),
                                ],
                              ),
                              10.height,
                              Text(
                                aboutTrip,
                                style: TextStyle(
                                    fontSize: textSizeLargeMedium,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.ubuntu().fontFamily),
                              ),
                              10.height,
                              Text(
                                widget.popularPackage.fullDetails.toString(),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor.withAlpha(153)
                                        : appTextColorPrimary
                                            .withAlpha(153),
                                    fontSize: textSizeSMedium,
                                    fontWeight: FontWeight.w400),
                              ),
                              10.height,
                              Text(
                                whatIncluded,
                                style: TextStyle(
                                    fontSize: textSizeLargeMedium,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.ubuntu().fontFamily),
                              ),
                              10.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 0;
                                      i <
                                          widget.popularPackage.includedList
                                              .length;
                                      i++)
                                    CategoryViewScreenState(
                                      category: widget
                                          .popularPackage.includedList[i],
                                      isDarkMode: isDarkMode,
                                      onPressed: () {
                                        switch (i) {
                                          case 0:
                                            FlightDetailsBottomSheet.show(
                                                context,
                                                widget.popularPackage
                                                    .ticketList,
                                                isDarkMode);
                                            break;
                                          case 1:
                                            break;
                                          case 2:
                                            HotelDetailsBottomSheet.show(
                                                context,
                                                widget
                                                    .popularPackage.hotelList,
                                                isDarkMode);
                                            break;
                                          case 3:
                                            break;
                                        }
                                      },
                                    ),
                                ],
                              ),
                              10.height,
                              Text(
                                imageAndVideos,
                                style: TextStyle(
                                    fontSize: textSizeLargeMedium,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.ubuntu().fontFamily),
                              ),
                              10.height,
                              StaggeredGrid.count(
                                crossAxisCount: 4,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                children: [
                                  StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 2,
                                      child: _buildRoundedImageview(widget
                                          .popularPackage.images[0].url
                                          .toString())),
                                  if (widget.popularPackage.images.length > 1)
                                    StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 1,
                                        child: _buildRoundedImageview(widget
                                            .popularPackage.images[1].url
                                            .toString())),
                                  if (widget.popularPackage.images.length > 2)
                                    StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: _buildRoundedImageview(widget
                                            .popularPackage.images[2].url
                                            .toString())),
                                  if (widget.popularPackage.images.length > 3)
                                    StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: _buildRoundedImageview(widget
                                            .popularPackage.images[3].url
                                            .toString()))
                                ],
                              ),
                              20.height,
                              Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: appColorPrimary.withAlpha(128),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0),
                                    ),
                                    elevation: 4,
                                    backgroundColor:
                                        appColorPrimary.withAlpha(128),
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    seeAllPhotos,
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.ubuntu().fontFamily,
                                        fontSize: textSizeMedium,
                                        fontWeight: FontWeight.w600,
                                        color: appColorPrimary),
                                  ),
                                ),
                              ),
                              20.height,
                              Text(
                                checkInMap,
                                style: TextStyle(
                                    fontSize: textSizeLargeMedium,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.ubuntu().fontFamily),
                              ),
                              10.height,
                              Container(
                                decoration: BoxDecoration(
                                  color: appColorPrimary.withAlpha(128),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                width: double.infinity,
                                height: 190,
                                child: commonCacheImageWidget(mapImages, 150),
                              ),
                              100.height,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: context.h * 0.2,
                  alignment: Alignment.topLeft,
                  margin:  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 16),
                  child: Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: SvgPicture.asset(
                      backIcon,
                    ),
                  ).onTap(() {
                    finish(context);
                  }),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 80,
                      color: isDarkMode
                          ? appBottomNavigationDarkColor
                          : whiteColor,
                      child: GradientElevatedButton(
                          gBgColor1: cancelColor.withAlpha(26),
                          gBgColor2: cancelColor.withAlpha(26),
                          textColor: cancelColor,
                          height: 50,
                          onPressed: () {
                            // Get.offNamed("/confirmation_screen/");
                          },
                          text: cancelThisTrip),
                    ))
              ],
            ),
          );
        });
  }

  _buildRoundedImageview(String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: commonCacheImageWidget(image, 0, fit: BoxFit.cover),
      ),
    );
  }
}
