import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../route/my_route.dart';



class BookingSuccessDialog {
  Future customDialog(
    BuildContext context,
    bool isDarkMode,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        final high = MediaQuery.of(context).size.width;
        return SimpleDialog(
          backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          children: [
            Container(
              // alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              width: high - 50,
              child: Column(
                children: [
                  SvgPicture.asset(
                    bookingSuccessImage,
                    width: 200,
                    height: 180,
                  ),
                  30.height,
                  const Text(congratulations,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: textSizeNormal,
                      )),
                  15.height,
                  Text(
                    bookingMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isDarkMode
                            ? whiteColor.withAlpha(153)
                            : appTextColorPrimary.withAlpha(153),
                        fontSize: textSizeSMedium),
                  ),
                  24.height,
                  GradientElevatedButton(
                      width: high / 6 * 3,
                      onPressed: () {
                        Get.offNamedUntil(
                            MyRoutes.mainDrawerScreen, (route) => false);
                      },
                      text: goBackHome),
                  30.height,
                  GradientElevatedButton(
                      width: high / 6 * 3,
                      gBgColor1: gradientBgColor1.withAlpha(38),
                      gBgColor2: gradientBgColor2.withAlpha(38),
                      textColor: appColorPrimary,
                      onPressed: () {
                        Get.offNamedUntil(
                            MyRoutes.mainDrawerScreen, (route) => false);
                        Get.toNamed(MyRoutes.boardingPass);
                      },
                      text: viewEReceipt),
                  20.height,
                ],
              ),
            )
          ],
          // content: ,
        );
      },
    );
  }
}
