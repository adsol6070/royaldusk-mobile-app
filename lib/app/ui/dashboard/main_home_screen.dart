import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../controller/main_home_controller.dart';
import '../saved/my_saved_screen.dart';
import '../setting/setting_screen.dart';
import '../trip/my_trip_screen.dart';
import 'home_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  MainHomeScreenState createState() => MainHomeScreenState();
}

class MainHomeScreenState extends State<MainHomeScreen>
    with TickerProviderStateMixin {
  late MainHomeController controller;

  late TabController tabController;
  late bool isDarkMode;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // Update any state that depends on inherited widgets or theme changes
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(MainHomeController());
    isDarkMode = controller.themeController.isDarkMode;
    // print("FFFFFF $isDarkMode");
    tabController = TabController(length: 4, vsync: this);
    ever(controller.currentIndex, (_) {
      tabController.animateTo(controller.currentIndex.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainHomeController>(
        init: controller,
        tag: 'travel_main_home',
        // theme: theme,
        builder: (controller) {
          return Align(
            alignment: Alignment.topLeft,
            child: Scaffold(
              backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
             /* appBar: MyAppBar(
                controller: controller, isDarkMode: isDarkMode,
              ),*/
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  HomeScreen(),
                  MyTripScreen(),
                  MySavedScreen(),
                  SettingScreen(),
                ],
              ) /* Obx(() => _getSelectedTab(controller.currentIndex.value))*/,
              bottomNavigationBar: Obx(() => _buildBottomNavigationBar()),
            ),
          );
        });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: appColorPrimary,
      // Color of selected item
      unselectedItemColor: controller.themeController.isDarkMode
          ? whiteColor.withAlpha(153)
          : appTextColorPrimary.withAlpha(153),
      backgroundColor: controller.themeController.isDarkMode
          ? appBottomNavigationDarkColor
          : Colors.white,
      type: BottomNavigationBarType.fixed,
      // selectedIconTheme: ,
      currentIndex: controller.currentIndex.value,
      onTap: controller.changeTabIndex,
      items: [
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            homeIcon,
          ),
          icon: SvgPicture.asset(
            homeUnselectedIcon,
            colorFilter: ColorFilter.mode(
              controller.themeController.isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              BlendMode.srcIn,
            ),
          ),
          label: home,
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(tripSelectedIcon),
          icon: SvgPicture.asset(
            tripIcon,
            colorFilter: ColorFilter.mode(
              controller.themeController.isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              BlendMode.srcIn,
            ),
          ),
          label: myTrip,
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(saveSelectedIcon),
          icon: SvgPicture.asset(
            saveIcon,
            colorFilter: ColorFilter.mode(
              controller.themeController.isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              BlendMode.srcIn,
            ),
          ),
          label: saved,
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(settingSelectedIcon),
          icon: SvgPicture.asset(
            settingIcon,
            colorFilter: ColorFilter.mode(
              controller.themeController.isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153),
              BlendMode.srcIn,
            ),
          ),
          label: settings,
        ),
        // Add more items as needed
      ],
    );
  }
}
