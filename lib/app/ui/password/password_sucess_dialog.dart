import 'dart:async';

import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../route/my_route.dart';

class PasswordSuccessDialog {
  Future customDialog(
    BuildContext context,
    bool isDarkMode,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
          //appStore.i += 1;
          if (timer.tick == 500) {
            timer.cancel();
          }
        });
        Timer(
          const Duration(seconds: 4),
          () {
            Get.offNamedUntil(
              MyRoutes.signIn,
              (route) => false,
            );
          },
        );
        final high = MediaQuery.of(context).size.width;
        return SimpleDialog(
          backgroundColor: context.scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          children: [
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                width: high / 6 * 3,
                child: FittedBox(
                  child: Column(
                    children: [
                      16.height,
                      SvgPicture.asset(
                        isDarkMode ? passDialogImage : passDialogLightImage,
                        width: 75,
                        height: 100,
                      ),
                      24.height,
                      const Text(passwordUpdated,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: textSizeLarge,
                          )),
                      15.height,
                      Text(
                        passwordSetUpSuccess,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: isDarkMode
                                ? whiteColor.withAlpha(153)
                                : appTextColorPrimary.withAlpha(153),
                            fontSize: textSizeMedium),
                      ),
                      24.height,
                      const SpinKitCircle(
                        color: loaderColor,
                        duration: Duration(seconds: 4),
                        size: 60,
                      ),
                      24.height,
                      GradientElevatedButton(
                        onPressed: () {
                          Get.offNamedUntil(
                            MyRoutes.signIn,
                            (route) => false,
                          );
                        },
                        text: backToSignIn,
                        width: high / 6 * 3,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
