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

import '../../controller/signup_controller.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  late SignUpController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(SignUpController(context));
    isDarkMode = controller.themeController.isDarkMode;

    final ButtonStyle iconBorderStyle = ElevatedButton.styleFrom(
      backgroundColor: isDarkMode ? whiteColor.withAlpha(31): whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
              color: borderColor.withAlpha(31),
              width: 1) // Adjust the radius as needed
      ),
    );

    return GetBuilder<SignUpController>(
        init: controller,
        tag: 'travel_signup',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            /*backgroundColor: themeChangeProvider.darkTheme
                ? appBackgroundColorDark
                : whiteColor,*/
            appBar: commonAppBarWidget(context, titleText: signUp),
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
                        Text(giveCredentialsToSignYourAcc,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: textSizeMedium,
                                color: isDarkMode
                                    ? whiteColor.withAlpha(153)
                                    : appTextColorPrimary.withAlpha(153))),
                        30.height,
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            fullName,
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
                          keyboardType: TextInputType.text,
                          focusNode: controller.f1,
                          onFieldSubmitted: (v) {
                            controller.f1.unfocus();
                            FocusScope.of(context).requestFocus(controller.f2);
                          },
                          validator: (value) {
                            return controller.validateName(value!);
                          },
                          controller: controller.nameController,
                          decoration: inputDecoration(context,
                              prefixIconColor:isDarkMode ? whiteColor : appTextColorPrimary,
                              borderColor: isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                              fillColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                              hintColor: isDarkMode ? whiteColor.withAlpha(153) : appTextColorPrimary.withAlpha(153),

                              prefixIcon: profileIcon,
                              borderRadius: textFieldRadius,
                              hintText: typeYourFullName),
                        ),
                        20.height,
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            email,
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
                          keyboardType: TextInputType.emailAddress,
                          focusNode: controller.f2,
                          onFieldSubmitted: (v) {
                            controller.f2.unfocus();
                            FocusScope.of(context).requestFocus(controller.f3);
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
                        20.height,
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
                          focusNode: controller.f3,
                          validator: (value) {
                            return controller.validate(value!);
                          },
                          onFieldSubmitted: (v) {
                            controller.f3.unfocus();
                            FocusScope.of(context).requestFocus(controller.f4);
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
                                  colorFilter:
                                      const ColorFilter.mode(gray, BlendMode.srcIn),
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
                          focusNode: controller.f4,
                          validator: (value) {
                            return controller.confirmPasswordValidate(value!);
                          },
                          onFieldSubmitted: (v) {
                            controller.f4.unfocus();
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
                                  colorFilter: const ColorFilter.mode(gray, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                        30.height,
                        GradientElevatedButton(
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.goToOtpScreen("signup");
                              }
                            },
                            text: signUp),
                        24.height,
                        SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      height: 0.2,
                                      color: isDarkMode
                                          ? Colors.white.withAlpha(153)
                                          : Colors.black26)),
                              10.width,
                              Text(orContinueWith, style: secondaryTextStyle()),
                              10.width,
                              Expanded(
                                  child: Container(
                                      height: 0.2,
                                      color: isDarkMode
                                          ? Colors.white.withAlpha(153)
                                          : Colors.black26)),
                            ],
                          ),
                        ),
                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: iconBorderStyle,
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: IconButton(
                                  icon: SvgPicture.asset(googleIcon),
                                  iconSize: iconSize,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            // TextButton(
                            //   style: iconBorderStyle,
                            //   onPressed: () {},
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //     child: IconButton(
                            //       icon: SvgPicture.asset(facebookIcon),
                            //       iconSize: iconSize,
                            //       onPressed: () {},
                            //     ),
                            //   ),
                            // ),
                            // TextButton(
                            //   style: iconBorderStyle,
                            //   onPressed: () {},
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //     child: IconButton(
                            //       icon: SvgPicture.asset(isDarkMode ? appleWhiteIcon :appleIcon),
                            //       iconSize: iconSize,
                            //       onPressed: () {},
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        8.height,
                        TextButton(
                          onPressed: () {
                            controller.goToBackScreen();
                          },
                          child: Text.rich(
                            TextSpan(
                              text: alreadyHaveAccount,
                              style: secondaryTextStyle(
                                size: textSizeMedium.toInt(),
                              ),
                              children: const [
                                TextSpan(
                                    text: signInWithSpace,
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
