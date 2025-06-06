
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';
import 'package:royaldusk_mobile_app/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'otp_text_field.dart';
import '../../controller/otp_verfication_controller.dart';



class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late OtpVerificationController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = OtpVerificationController();
    isDarkMode = controller.themeController.isDarkMode;
    return GetBuilder<OtpVerificationController>(
        init: controller,
        tag: 'travel_otp',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            /*backgroundColor: themeChangeProvider.darkTheme
                ? appBackgroundColorDark
                : whiteColor,*/
            appBar: commonAppBarWidget(context, titleText: verification),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(appLogo, height: 32, width: 32)
                                .center(),
                            10.width,
                            Text(appName.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: GoogleFonts.saira().fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.4,
                                )),
                          ],
                        ),
                        15.height,
                        Text(sendVerificationCode,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: textSizeMedium,
                                color: isDarkMode
                                    ? Colors.white.withAlpha(153)
                                    : appTextColorPrimary.withAlpha(153))),
                        8.height,
                        const Text(verificationSentOn,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: textSizeMedium,
                            )),
                        30.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: OtpTextField(
                                focusNode: controller.focusNodes[index],
                                onTextChanged: (value) {
                                  controller.otpValues[index] = value;
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ),
                        ),
                        30.height,
                        GradientElevatedButton(
                            onPressed: () {
                              if (controller.validateOtp()) {
                                // if (controller.formKey.currentState!.validate()) {
                                controller.goToNextScreen();
                              }
                            },
                            text: confirm),
                        24.height,
                        TextButton(
                          onPressed: () {},
                          child: Text.rich(
                            TextSpan(
                              text: getCode,
                              style: TextStyle(
                                  fontSize: textSizeMedium,
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153)),
                              children: const [
                                TextSpan(
                                    text: resend,
                                    style: TextStyle(
                                        letterSpacing: 0.25,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textSizeMedium,
                                        color: appColorAccent)),
                              ],
                            ),
                          ),
                        ).center(),
                        10.height,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
