import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class SettingController extends GetxController {
  bool isNotification = false;
  bool isDarkMode = false;
  bool isEmailNotification = false;
  // late ThemeProvider themeProvider;
  final ThemeController themeController = Get.put(ThemeController());

  // DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  late BuildContext context;

  SettingController({required this.context});

  @override
  void onInit() {
    // Load theme settings and initialize notification flags
    super.onInit();
    isDarkMode = themeController.isDarkMode;

    // themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // isDarkMode = themeProvider.getTheme == Styles.darkTheme;
  }
}
