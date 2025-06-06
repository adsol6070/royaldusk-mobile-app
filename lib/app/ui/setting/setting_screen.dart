import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';


import '../../../constant/strings.dart';
import '../../controller/setting_controller.dart';
import '../my_app_bar.dart';
import 'custom_setting_item.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  late SettingController controller;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(SettingController(context: context));

    return GetBuilder<SettingController>(
        init: controller,
        tag: 'travel_setting',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            backgroundColor: controller.isDarkMode ? appDarkBgColor : appLightBgColor,
            appBar: MyAppBar(
              /*  controller: controller,*/ isDarkMode: controller.isDarkMode,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  20.height,
                  CustomSettingItem(
                    isSwitchShow: true,
                    text1: notification,
                    value: controller.isNotification,
                    isDarkTheme: controller.isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        controller.isNotification = value;
                      });
                    },
                  ),
                  5.height,
                  Divider(
                    color: controller.isDarkMode
                        ? whiteColor.withAlpha(204)
                        : appTextColorPrimary.withAlpha(204),
                  ),
                  CustomSettingItem(
                    isSwitchShow: true,
                    text1: darkMode,
                    value: controller.isDarkMode,
                    isDarkTheme: controller.isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        controller.isDarkMode = value;
                        controller.themeController.toggleTheme();
                      });
                    },
                  ),
                  5.height,
                  Divider(
                    color: controller.isDarkMode
                        ? whiteColor.withAlpha(204)
                        : appTextColorPrimary.withAlpha(204),
                  ),
                  CustomSettingItem(
                    isSwitchShow: true,
                    text1: emailNotification,
                    value: controller.isEmailNotification,
                    isDarkTheme: controller.isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        controller.isEmailNotification = value;
                      });
                    },
                  ),
                  5.height,
                  Divider(
                    color: controller.isDarkMode
                        ? whiteColor.withAlpha(204)
                        : appTextColorPrimary.withAlpha(204),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomSettingItem(
                      isIconShow: true,
                      text1: aboutApp,
                      isDarkTheme: controller.isDarkMode,
                    ),
                  ),
                  5.height,
                  Divider(
                    color: controller.isDarkMode
                        ? whiteColor.withAlpha(204)
                        : appTextColorPrimary.withAlpha(204),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomSettingItem(
                      isIconShow: true,
                      text1: shareApp,
                      isDarkTheme: controller.isDarkMode,
                    ),
                  ),
                  5.height,
                  Divider(
                    color: controller.isDarkMode
                        ? whiteColor.withAlpha(204)
                        : appTextColorPrimary.withAlpha(204),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
