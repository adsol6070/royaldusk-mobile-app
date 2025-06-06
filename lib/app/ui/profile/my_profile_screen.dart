import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../controller/profile_controller.dart';
import '../drawer/profile_imae.dart';
import 'custom_row_text_icon.dart';



class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  late ProfileController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController(context));
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: controller,
        tag: 'travel_profile',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: commonAppBarWidget(context, titleText: myProfile),
            resizeToAvoidBottomInset: true,
            backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                // physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const UserProfilePicture(),
                        20.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomRowTextAndIcon(
                            title: name,
                            onPressed: () {},
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        15.height,
                        TextFormField(
                          style:  TextStyle(
                            color:  isDarkMode ? whiteColor : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: controller.f1,
                          onFieldSubmitted: (v) {
                            controller.f1.unfocus();
                            FocusScope.of(context).requestFocus(controller.f2);
                          },
                          validator: (k) {
                            return null;
                          },
                          controller: controller.nameController,
                          decoration: inputDecoration(context,
                              prefixIconColor:isDarkMode ? whiteColor : appTextColorPrimary,
                              borderColor: isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                              fillColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                              hintColor: isDarkMode ? whiteColor.withAlpha(153) : appTextColorPrimary.withAlpha(153),
              
                              prefixIcon: profileIcon,
                              borderRadius: textFieldRadius,
                              hintText: typeYourName),
                        ),
                        30.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomRowTextAndIcon(
                            title: email,
                            onPressed: () {},
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        15.height,
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
                        30.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomRowTextAndIcon(
                            title: phoneNumber,
                            onPressed: () {},
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        15.height,
                        TextFormField(
                          style:  TextStyle(
                            color:  isDarkMode ? whiteColor : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.phone,
                          focusNode: controller.f3,
                          onFieldSubmitted: (v) {
                            controller.f3.unfocus();
                          },
                          validator: (k) {
                            return null;
                          },
                          controller: controller.phoneController,
                          decoration: inputDecoration(context,
                              prefixIconColor:isDarkMode ? whiteColor : appTextColorPrimary,
                              borderColor: isDarkMode ? whiteColor.withAlpha(31) : appTextColorPrimary.withAlpha(31),
                              fillColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                              hintColor: isDarkMode ? whiteColor.withAlpha(153) : appTextColorPrimary.withAlpha(153),
              
                              prefixIcon: smsIcon,
                              borderRadius: textFieldRadius,
                              hintText: typePhoneNumber),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GradientElevatedButton(
                text: update,
                onPressed: () {},
                textColor: appColorPrimary,
                gBgColor1: gradientBgColor1.withAlpha(26),
                gBgColor2: gradientBgColor1.withAlpha(26),
              ),
            ),
          );
        });
  }
}
