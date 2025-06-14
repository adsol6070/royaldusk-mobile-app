import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../route/my_route.dart';
import '../../../widgets/custom_textview_with_diff_color.dart';
import '../../../widgets/custom_textview_with_icon.dart';
import '../../../widgets/grediant_button.dart';
import '../../controller/popular_package_detail_controller.dart';
import '../../model/popular_packages.dart';
// import '../dashboard/category_view.dart';
import 'check_availability_bottom_sheet.dart';
import 'custom_review_rating_view.dart';
// import 'flight_details_bottom_sheet.dart';
// import 'hotel_details_bottom_sheet.dart';

class PopularPackageDetailScreenVersion2 extends StatefulWidget {
  final PopularPackage popularPackage;

  const PopularPackageDetailScreenVersion2(
      {Key? key, required this.popularPackage})
      : super(key: key);

  @override
  PopularPackageDetailScreenState createState() =>
      PopularPackageDetailScreenState();
}

class PopularPackageDetailScreenState
    extends State<PopularPackageDetailScreenVersion2> {
  late PopularPackageDetailController controller;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = PopularPackageDetailController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularPackageDetailController>(
        init: controller,
        tag: 'travel_popular_packages_detail',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(10),
                height: 80,
                color: isDarkMode ? appBottomNavigationDarkColor : whiteColor,
                child: GradientElevatedButton(
                    height: 50,
                    onPressed: () {
                      Get.offNamed(MyRoutes.confirmationScreen);
                    },
                    text: bookNow),
              ),
              body: NestedScrollView(
                headerSliverBuilder:
                    ((BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        expandedHeight: 250,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: commonCacheImageWidget(
                              widget.popularPackage.imageUrl, 250),
                          collapseMode: CollapseMode.parallax,
                        ),
                        // backgroundColor: appStore.appBarColor,
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 25,
                            height: 25,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: SvgPicture.asset(
                              backIcon,
                              colorFilter: ColorFilter.mode(
                                  innerBoxIsScrolled
                                      ? Colors.black
                                      : Colors.black,
                                  BlendMode.srcIn),
                            ),
                          ).onTap(() {
                            finish(context);
                          }),
                        )),
                  ];
                }),
                body: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    // color: Colors.black,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ? Colors.white.withAlpha(26)
                                          : appTextColorPrimary.withAlpha(26)),
                                  borderRadius: BorderRadius.circular(8)),
                              child: SvgPicture.asset(
                                bookmarkOnlyIcon,
                              ),
                            ).onTap(() {}),
                          ],
                        ),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextViewWithIcon(
                                  fontWeight: FontWeight.w500,
                                  fontSize: textSizeMedium,
                                  text:
                                      widget.popularPackage.location.toString(),
                                  icon: mapIcon,
                                  isDarkMode: isDarkMode),
                            ),
                            CustomTextViewWithStyle(
                              fontSize: textSizeMedium,
                              text1: widget.popularPackage.price.toString(),
                              text2: person,
                              isDarkMode: isDarkMode,
                              fontWeight: FontWeight.w500,
                            )
                          ],
                        ),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomReviewRatingViewScreen(
                              reviewCount: widget.popularPackage.review,
                              rating: 4.7,
                            ),
                            8.width,
                            Row(children: [
                              SvgPicture.asset(
                                starIcon,
                                height: 20,
                                width: 20,
                              ),
                              2.width,
                              const Text(
                                "5.0",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: textSizeMedium),
                              ),
                            ]),
                            8.width,
                            Expanded(
                              child: GradientElevatedButton(
                                  fontSize: textSizeSmall,
                                  height: 45,
                                  onPressed: () {
                                    CheckAvailabilityBottomSheet.show(
                                        context, isDarkMode);
                                  },
                                  text: checkAvailability),
                            ),
                          ],
                        ),
                        10.height,
                        Text(
                          aboutTrip,
                          style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.ubuntu().fontFamily),
                        ),
                        10.height,
                        Text(
                          widget.popularPackage.description.toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: isDarkMode
                                  ? whiteColor.withAlpha(153)
                                  : appTextColorPrimary.withAlpha(153),
                              fontSize: textSizeSMedium,
                              fontWeight: FontWeight.w400),
                        ),
                        10.height,
                        Text(
                          whatIncluded,
                          style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.ubuntu().fontFamily),
                        ),
                        10.height,
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     for (int i = 0;
                        //         i < widget.popularPackage.inclusions.length;
                        //         i++)
                        //       CategoryViewScreenState(
                        //         category: widget.popularPackage.inclusions[i],
                        //         isDarkMode: isDarkMode,
                        //         onPressed: () {
                        //           switch (i) {
                        //             case 0:
                        //               FlightDetailsBottomSheet.show(
                        //                   context,
                        //                   widget.popularPackage.ticketList,
                        //                   isDarkMode);
                        //               break;
                        //             case 1:
                        //               break;
                        //             case 2:
                        //               HotelDetailsBottomSheet.show(
                        //                   context,
                        //                   widget.popularPackage.hotelList,
                        //                   isDarkMode);
                        //               break;
                        //             case 3:
                        //               break;
                        //           }
                        //         },
                        //       ),
                        //   ],
                        // ),
                        10.height,
                        Text(
                          imageAndVideos,
                          style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.ubuntu().fontFamily),
                        ),
                        10.height,
                        StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 4,
                              mainAxisCellCount: 2,
                              child: _buildRoundedImageview(
                                  widget.popularPackage.imageUrl),
                            ),
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
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 4,
                              backgroundColor: appColorPrimary.withAlpha(128),
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {},
                            child: Text(
                              seeAllPhotos,
                              style: TextStyle(
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
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
                              fontFamily: GoogleFonts.ubuntu().fontFamily),
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
              ));
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
