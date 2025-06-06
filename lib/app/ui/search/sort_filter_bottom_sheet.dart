import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import 'cat_view.dart';



class SearchSortFilterBottomSheet extends StatefulWidget {
  final bool isDarkMode;

  const SearchSortFilterBottomSheet({super.key, required this.isDarkMode});

  @override
  SearchSortFilterBottomSheetState createState() =>
      SearchSortFilterBottomSheetState();
}

class SearchSortFilterBottomSheetState
    extends State<SearchSortFilterBottomSheet> {
  List<String> categoryList = ["All", "Package", "Hotel"];
  List<String> sortByList = ["Popular", "Most Visited", "Trending Now"];
  List<String> rattingList = ["All", "5", "4", "3", "2", "1"];
  int selectedCatIndex = 0;
  int selectedSortByIndex = 1;
  int selectedRattingIndex = 1;
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    // Builds the bottom sheet containing sorting and filtering options
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.isDarkMode
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      widget.isDarkMode ? closeSquareWhiteIcon : closeSquareIcon,
                      width: 25,
                      height: 25,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        sortFilter,
                        style: TextStyle(
                          fontSize: textSizeNormal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 20.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                  color: widget.isDarkMode
                      ? whiteColor.withAlpha(26)
                      : appTextColorPrimary.withAlpha(26),
                  height: 1),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildTitleText(categories),
                    10.height,
                    HorizontalList(
                      itemCount: categoryList.length,
                      itemBuilder: (ctx, i) {
                        String cat = categoryList[i];
                        // controller.allCategories[0].isSelected = true;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCatIndex = i;
                            });
                          },
                          child: CategoryView(
                            i: i,
                            isDarkMode: widget.isDarkMode,
                            name: cat,
                            selectedCatIndex: selectedCatIndex,
                            isShowRattingIcon: false,
                          ),
                        );
                      },
                    ),
                    10.height,
                    _buildTitleText(priceRange),
                    10.height,
                    RangeSlider(
                      activeColor: appColorPrimary,
                      inactiveColor: widget.isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                      values: _currentRangeValues,
                      max: 100,
                      divisions: 5,
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                    10.height,
                    _buildTitleText(sortByTitle),
                    10.height,
                    HorizontalList(
                      itemCount: sortByList.length,
                      itemBuilder: (ctx, i) {
                        String cat = sortByList[i];
                        // controller.allCategories[0].isSelected = true;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSortByIndex = i;
                            });
                          },
                          child: CategoryView(
                            i: i,
                            isDarkMode: widget.isDarkMode,
                            name: cat,
                            selectedCatIndex: selectedSortByIndex,
                            isShowRattingIcon: false,
                          ),
                        );
                      },
                    ),
                    10.height,
                    _buildTitleText(ratings),
                    10.height,
                    HorizontalList(
                      itemCount: rattingList.length,
                      itemBuilder: (ctx, i) {
                        String cat = rattingList[i];
                        // controller.allCategories[0].isSelected = true;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRattingIndex = i;
                            });
                          },
                          child: CategoryView(
                            i: i,
                            isDarkMode: widget.isDarkMode,
                            name: cat,
                            selectedCatIndex: selectedRattingIndex,
                            isShowRattingIcon: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            5.height,
            Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  // color: widget.isDarkMode ? darkCardBg : appLightBgColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GradientElevatedButton(
                        text: reset,
                        onPressed: () {},
                        textColor: appColorPrimary,
                        gBgColor1: gradientBgColor1.withAlpha(128),
                        gBgColor2: gradientBgColor2.withAlpha(128),
                        boxBorder: Border.all(
                          color: appColorPrimary,
                          width: 1,
                        ),
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: GradientElevatedButton(
                        text: apply,
                        onPressed: () {},
                      ),
                    ),
                  ],
                )),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}

_buildTitleText(String text) {
  return Text(
    text,
    style: TextStyle(
        fontSize: textSizeMedium,
        fontWeight: FontWeight.w600,
        fontFamily: GoogleFonts
            .ubuntu()
            .fontFamily),
  );
}
