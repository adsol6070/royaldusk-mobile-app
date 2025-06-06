import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import 'custom_calendar.dart';

class CheckAvailabilityBottomSheet {
  static void show(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: _buildBottomSheetContent(isDarkMode));
        // return _buildBottomSheetContent(isDarkMode);
      },
    );
  }

  static Widget _buildBottomSheetContent(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
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
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset(
                  isDarkMode ? closeSquareWhiteIcon : closeSquareIcon,
                  width: 25,
                  height: 25,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    checkAvailability,
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
            child: ListView(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: isDarkMode ? darkCardBg : whiteColor,
                    ),
                    child: const CustomCalendarScreen()),
              ],
            ),
          ),
          20.height,
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: isDarkMode ? darkCardBg : whiteColor,
              ),
              child: GradientElevatedButton(text: next, onPressed: () {  },)),
          // Add more widgets as needed
        ],
      ),
    );
  }
}
