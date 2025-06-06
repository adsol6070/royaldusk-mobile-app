import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';
import 'package:royaldusk_mobile_app/constant/strings.dart';

import '../../controller/reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = ResetPasswordController();
    isDarkMode = controller.themeController.isDarkMode;

    return GetBuilder<ResetPasswordController>(
        init: controller,
        tag: 'travel_reset_password',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            /*backgroundColor: themeChangeProvider.darkTheme
                ? appBackgroundColorDark
                : whiteColor,*/
            appBar: commonAppBarWidget(context, titleText: security),
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
                        const Text(resetPassword,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              fontSize: textSizeMedium,
                            )),
                        15.height,
                        Text(enterEmailAddressToReqPass,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4,
                                fontSize: textSizeMedium,
                                color: isDarkMode
                                    ? Colors.white.withAlpha(153)
                                    : appTextColorPrimary.withAlpha(153))),
                        30.height,
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            email,
                            style: TextStyle(
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        8.height,
                        TextFormField(
                          style:  TextStyle(
                            color:  isDarkMode ? whiteColor : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: controller.f1,
                          onFieldSubmitted: (v) {
                            controller.f1.unfocus();
                          },
                          validator: (k) {
                            if (!k!.contains('@')) {
                              return errEmailCorrect;
                            }
                            return null;
                          },
                          controller: controller.emailController,
                          decoration: inputDecoration(context,
                              prefixIconColor:isDarkMode ? whiteColor : appTextColorPrimary,
                              borderColor: isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                              fillColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                              hintColor: isDarkMode ? whiteColor.withAlpha(153) : appTextColorPrimary.withAlpha(153),
              
                              prefixIcon: smsIcon,
                              borderRadius: textFieldRadius,
                              hintText: typeEmail),
                        ),
                        30.height,
                        GradientElevatedButton(
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.goToVerifyScreen();
                              }
                            },
                            text: continueText),
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
