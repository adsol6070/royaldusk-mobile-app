import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/constant/strings.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late SplashController controller;

  @override
  void initState() {
    super.initState();
    controller = SplashController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: controller,
        tag: 'travel_splash',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            /*  backgroundColor: themeChangeProvider.darkTheme
                ? appBackgroundColorDark
                : whiteColor,*/
            body: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(appLogo, height: 45, width: 45).center(),
                    10.width,
                    Text(appName.toUpperCase(),
                        style: TextStyle(
                          fontFamily: GoogleFonts.saira().fontFamily,
                          fontSize: 26,
                        )),
                  ],
                ),
                const Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: SpinKitCircle(
                      color: loaderColor, duration: Duration(seconds: 2)),
                ),
              ],
            ),
          );
        });
  }
}
