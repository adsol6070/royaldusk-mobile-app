import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../dashboard/main_home_screen.dart';
import 'menu_screen.dart';

class MainDrawerScreen extends StatelessWidget {
  MainDrawerScreen({super.key});

  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      moveMenuScreen: false,
      controller: zoomDrawerController,
      style: DrawerStyle.defaultStyle,
      menuScreen: const MenuScreen(),
      mainScreen: const MainHomeScreen(),
      borderRadius: 24.0,
      showShadow: true,
      angle: -10.0,
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
      menuBackgroundColor: appColorPrimary,
    );
  }
}
