import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';
import 'package:royaldusk_mobile_app/constant/strings.dart';
import '../../controller/signin_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  late SignInController controller;
  late AuthController authController;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    // Initialize AuthController first
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(SignInController(context));
    isDarkMode = controller.themeController.isDarkMode;

    final ButtonStyle iconBorderStyle = ElevatedButton.styleFrom(
      backgroundColor: isDarkMode ? whiteColor.withAlpha(31) : whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: borderColor.withAlpha(31), width: 1)),
    );

    return GetBuilder<SignInController>(
        init: controller,
        tag: 'travel_signin',
        builder: (controller) {
          return Scaffold(
            appBar: commonAppBarWidget(context, titleText: signIn),
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
                                        letterSpacing: 0.4,
                                        fontSize: textSizeMedium,
                                        color: isDarkMode
                                            ? whiteColor.withAlpha(153)
                                            : appTextColorPrimary
                                                .withAlpha(153))),
                                30.height,

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
                                  focusNode: controller.f1,
                                  onFieldSubmitted: (v) =>
                                      controller.moveToPasswordField(),
                                  validator: (value) =>
                                      controller.validateEmail(value ?? ''),
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
                                  textInputAction: TextInputAction.done,
                                  controller: controller.passwordController,
                                  obscureText: controller.isIconTrue,
                                  focusNode: controller.f2,
                                  validator: (value) =>
                                      controller.validate(value!),
                                  onFieldSubmitted: (v) {
                                    controller.f2.unfocus();
                                    if (controller.formKey.currentState!
                                        .validate()) {
                                      controller.loginUser();
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
                                          controller.isIconTrue
                                              ? eyeIcon
                                              : eyeSplashIcon,
                                          width: 16,
                                          height: 16,
                                          colorFilter: const ColorFilter.mode(
                                              gray, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                10.height,

                                // Remember Me and Forgot Password
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.6,
                                          child: CupertinoSwitch(
                                            value: controller.rememberMe,
                                            onChanged:
                                                controller.toggleRememberMe,
                                          ),
                                        ),
                                        Text(rememberMe,
                                            style: TextStyle(
                                                color: isDarkMode
                                                    ? whiteColor.withAlpha(153)
                                                    : appTextColorPrimary
                                                        .withAlpha(153))),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed:
                                          controller.goToForgotPasswordScreen,
                                      child: Text(forgotPassword,
                                          style: primaryTextStyle(
                                            color: appColorPrimary,
                                          )),
                                    ),
                                  ],
                                ),
                                16.height,

                                // Sign In Button with loading state
                                GradientElevatedButton(
                                  onPressed: () {
                                    if (!(controller.isLoading.value ||
                                        authController.isLoading)) {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        controller.loginUser();
                                      }
                                    }
                                  },
                                  text: (controller.isLoading.value ||
                                          authController.isLoading)
                                      ? 'Signing In...'
                                      : signIn,
                                ),
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

                                // Social Login Buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      style: iconBorderStyle,
                                      onPressed: () {
                                        Get.snackbar('Coming Soon',
                                            'Google Sign In will be available soon');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: IconButton(
                                          icon: SvgPicture.asset(googleIcon),
                                          iconSize: iconSize,
                                          onPressed: () {
                                            Get.snackbar('Coming Soon',
                                                'Google Sign In will be available soon');
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                8.height,

                                // Sign Up Link
                                TextButton(
                                  onPressed: controller.goToSignUpScreen,
                                  child: Text.rich(
                                    TextSpan(
                                      text: dontHaveAccount,
                                      style: secondaryTextStyle(
                                        size: textSizeMedium.toInt(),
                                      ),
                                      children: const [
                                        TextSpan(
                                            text: signUpWithSpace,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.4,
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
                      if (controller.isLoading.value ||
                          authController.isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  )),
            ),
          );
        });
  }
}
