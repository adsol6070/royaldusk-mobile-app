import 'package:royaldusk_mobile_app/app/ui/password/password_sucess_dialog.dart';
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

import '../../controller/new_password_controller.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  NewPasswordScreenState createState() => NewPasswordScreenState();
}

class NewPasswordScreenState extends State<NewPasswordScreen> {
  late NewPasswordController controller;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = NewPasswordController();
    isDarkMode = controller.themeController.isDarkMode;

    return GetBuilder<NewPasswordController>(
        init: controller,
        tag: 'travel_new_password',
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
                        const Text(newPassword,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              fontSize: textSizeMedium,
                            )),
                        15.height,
                        Text(newPassDesc,
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
                            password,
                            style: TextStyle(
                                letterSpacing: 0.4, fontWeight: FontWeight.bold),
                          ),
                        ),
                        8.height,
                        TextFormField(
                          style:  TextStyle(
                            color:  isDarkMode ? whiteColor : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.next,
                          controller: controller.passwordController,
                          obscureText: controller.isIconTrue,
                          focusNode: controller.f1,
                          validator: (value) {
                            return controller.validate(value!);
                          },
                          onFieldSubmitted: (v) {
                            controller.f1.unfocus();
                            FocusScope.of(context).requestFocus(controller.f2);
                          },
                          decoration: inputDecoration(
                            context,
                            prefixIconColor:isDarkMode ? whiteColor : appTextColorPrimary,
                            borderColor: isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                            fillColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                            hintColor: isDarkMode ? whiteColor.withAlpha(153) : appTextColorPrimary.withAlpha(153),
                            prefixIcon: passwordIcon,
                            hintText: typePassword,
                            borderRadius: textFieldRadius,
                            suffixIcon: Theme(
                              data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent),
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    controller.isIconTrue =
                                        !controller.isIconTrue;
                                  });
                                },
                                icon: SvgPicture.asset(
                                  (controller.isIconTrue)
                                      ? eyeIcon
                                      : eyeSplashIcon,
                                  width: 16,
                                  height: 16,
                                  colorFilter:const ColorFilter.mode(gray, BlendMode.srcIn) ,
                                ),
                              ),
                            ),
                          ),
                        ),
                        20.height,
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            confirmPassword,
                            style: TextStyle(
                                letterSpacing: 0.4, fontWeight: FontWeight.bold),
                          ),
                        ),
                        8.height,
                        TextFormField(
                          style:  TextStyle(
                            color:  isDarkMode ? whiteColor : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.done,
                          controller: controller.confirmPasswordController,
                          obscureText: controller.isConPassIconTrue,
                          focusNode: controller.f2,
                          validator: (value) {
                            return controller.confirmPasswordValidate(value!);
                          },
                          onFieldSubmitted: (v) {
                            controller.f2.unfocus();
                          },
                          decoration: inputDecoration(
                            context,
                            prefixIconColor:isDarkMode ? whiteColor : appTextColorPrimary,
                            borderColor: isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                            fillColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                            hintColor: isDarkMode ? whiteColor.withAlpha(153) : appTextColorPrimary.withAlpha(153),
              
                            prefixIcon: passwordIcon,
                            hintText: reTypePassword,
                            borderRadius: textFieldRadius,
                            suffixIcon: Theme(
                              data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent),
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    controller.isConPassIconTrue =
                                        !controller.isConPassIconTrue;
                                  });
                                },
                                icon: SvgPicture.asset(
                                  (controller.isConPassIconTrue)
                                      ? eyeIcon
                                      : eyeSplashIcon,
                                  width: 16,
                                  height: 16,
                                  colorFilter:const ColorFilter.mode(gray, BlendMode.srcIn) ,
                                ),
                              ),
                            ),
                          ),
                        ),
                        30.height,
                        GradientElevatedButton(
                            onPressed: () async {
                              if (controller.formKey.currentState!.validate()) {
                                await PasswordSuccessDialog()
                                    .customDialog(context, isDarkMode);
                                // controller.goToNextScreen();
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
