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
      backgroundColor: isDarkMode ? whiteColor.withAlpha(31) : whiteColor,
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
        builder: (controller) {
          return Scaffold(
            appBar: commonAppBarWidget(context, titleText: signUp),
            body: SafeArea(
              child: Obx(() => Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // App Logo and Name
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(appLogo,
                                            height: 32, width: 32)
                                        .center(),
                                    10.width,
                                    Text(appName.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.saira().fontFamily,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.4,
                                        )),
                                  ],
                                ),
                                15.height,

                                // Subtitle
                                Text(giveCredentialsToSignYourAcc,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: textSizeMedium,
                                        color: isDarkMode
                                            ? whiteColor.withAlpha(153)
                                            : appTextColorPrimary
                                                .withAlpha(153))),
                                30.height,

                                // Full Name Field
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    fullName,
                                    style: TextStyle(
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                8.height,
                                TextFormField(
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  focusNode: controller.f1,
                                  onFieldSubmitted: (v) =>
                                      controller.moveToEmail(),
                                  validator: controller.validateName,
                                  controller: controller.nameController,
                                  decoration: inputDecoration(context,
                                      prefixIconColor: isDarkMode
                                          ? whiteColor
                                          : appTextColorPrimary,
                                      borderColor: isDarkMode
                                          ? whiteColor.withAlpha(31)
                                          : appTextColorPrimary.withAlpha(31),
                                      fillColor: isDarkMode
                                          ? appDarkBgColor
                                          : appLightBgColor,
                                      hintColor: isDarkMode
                                          ? whiteColor.withAlpha(153)
                                          : appTextColorPrimary.withAlpha(153),
                                      prefixIcon: profileIcon,
                                      borderRadius: textFieldRadius,
                                      hintText: typeYourFullName),
                                ),
                                20.height,

                                // Email Field
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    email,
                                    style: TextStyle(
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                8.height,
                                TextFormField(
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  focusNode: controller.f2,
                                  onFieldSubmitted: (v) =>
                                      controller.moveToPassword(),
                                  validator: controller.validateEmail,
                                  controller: controller.emailController,
                                  decoration: inputDecoration(context,
                                      prefixIconColor: isDarkMode
                                          ? whiteColor
                                          : appTextColorPrimary,
                                      borderColor: isDarkMode
                                          ? whiteColor.withAlpha(31)
                                          : appTextColorPrimary.withAlpha(31),
                                      fillColor: isDarkMode
                                          ? appDarkBgColor
                                          : appLightBgColor,
                                      hintColor: isDarkMode
                                          ? whiteColor.withAlpha(153)
                                          : appTextColorPrimary.withAlpha(153),
                                      prefixIcon: smsIcon,
                                      borderRadius: textFieldRadius,
                                      hintText: typeEmail),
                                ),
                                20.height,

                                // Password Field
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    password,
                                    style: TextStyle(
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                8.height,
                                TextFormField(
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: controller.passwordController,
                                  obscureText: !controller.isIconTrue.value,
                                  focusNode: controller.f3,
                                  validator: controller.validatePassword,
                                  onFieldSubmitted: (v) =>
                                      controller.moveToConfirmPassword(),
                                  decoration: inputDecoration(
                                    context,
                                    prefixIconColor: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                    borderColor: isDarkMode
                                        ? whiteColor.withAlpha(31)
                                        : appTextColorPrimary.withAlpha(31),
                                    fillColor: isDarkMode
                                        ? appDarkBgColor
                                        : appLightBgColor,
                                    hintColor: isDarkMode
                                        ? whiteColor.withAlpha(153)
                                        : appTextColorPrimary.withAlpha(153),
                                    prefixIcon: passwordIcon,
                                    hintText: typePassword,
                                    borderRadius: textFieldRadius,
                                    suffixIcon: Theme(
                                      data: ThemeData(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent),
                                      child: IconButton(
                                        highlightColor: Colors.transparent,
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                        icon: SvgPicture.asset(
                                          controller.isIconTrue.value
                                              ? eyeSplashIcon
                                              : eyeIcon,
                                          width: 16,
                                          height: 16,
                                          colorFilter: const ColorFilter.mode(
                                              gray, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                20.height,

                                // Confirm Password Field
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    confirmPassword,
                                    style: TextStyle(
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                8.height,
                                TextFormField(
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  controller:
                                      controller.confirmPasswordController,
                                  obscureText:
                                      !controller.isConPassIconTrue.value,
                                  focusNode: controller.f4,
                                  validator: controller.validateConfirmPassword,
                                  onFieldSubmitted: (v) {
                                    controller.f4.unfocus();
                                    if (controller.formKey.currentState!
                                            .validate() &&
                                        controller.isChecked.value) {
                                      controller.signUpUser();
                                    }
                                  },
                                  decoration: inputDecoration(
                                    context,
                                    prefixIconColor: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                    borderColor: isDarkMode
                                        ? whiteColor.withAlpha(31)
                                        : appTextColorPrimary.withAlpha(31),
                                    fillColor: isDarkMode
                                        ? appDarkBgColor
                                        : appLightBgColor,
                                    hintColor: isDarkMode
                                        ? whiteColor.withAlpha(153)
                                        : appTextColorPrimary.withAlpha(153),
                                    prefixIcon: passwordIcon,
                                    hintText: reTypePassword,
                                    borderRadius: textFieldRadius,
                                    suffixIcon: Theme(
                                      data: ThemeData(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent),
                                      child: IconButton(
                                        highlightColor: Colors.transparent,
                                        onPressed: controller
                                            .toggleConfirmPasswordVisibility,
                                        icon: SvgPicture.asset(
                                          controller.isConPassIconTrue.value
                                              ? eyeSplashIcon
                                              : eyeIcon,
                                          width: 16,
                                          height: 16,
                                          colorFilter: const ColorFilter.mode(
                                              gray, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                20.height,

                                // Terms and Conditions Checkbox
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Checkbox(
                                        value: controller.isChecked.value,
                                        onChanged:
                                            controller.toggleTermsAcceptance,
                                        activeColor: appColorPrimary,
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.toggleTermsAcceptance(
                                                !controller.isChecked.value),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'I agree to the ',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? whiteColor.withAlpha(179)
                                                  : appTextColorPrimary
                                                      .withAlpha(179),
                                              fontSize: textSizeSmall,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Terms and Conditions',
                                                style: TextStyle(
                                                  color: appColorPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              const TextSpan(text: ' and '),
                                              TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(
                                                  color: appColorPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                20.height,

                                // Sign Up Button
                                GradientElevatedButton(
                                    onPressed: () {
                                      if (!controller.isLoading &&
                                          controller.formKey.currentState!
                                              .validate()) {
                                        controller.signUpUser();
                                      }
                                    },
                                    text: controller.isLoading
                                        ? 'Creating Account...'
                                        : signUp),
                                24.height,

                                // Divider
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
                                      Text(orContinueWith,
                                          style: secondaryTextStyle()),
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

                                // Social Signup Buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      style: iconBorderStyle,
                                      onPressed: () {
                                        // TODO: Implement Google signup
                                        Get.snackbar('Coming Soon',
                                            'Google Sign Up will be available soon');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: IconButton(
                                          icon: SvgPicture.asset(googleIcon),
                                          iconSize: iconSize,
                                          onPressed: null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                8.height,

                                // Sign In Link
                                TextButton(
                                  onPressed: controller.goToSignInScreen,
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

                      // Loading Overlay
                      if (controller.isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDarkMode ? appDarkBgColor : whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Creating Account...',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? whiteColor
                                          : appTextColorPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please wait while we set up your account',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? whiteColor.withAlpha(153)
                                          : appTextColorPrimary.withAlpha(153),
                                      fontSize: textSizeSmall,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
            ),
          );
        });
  }
}
