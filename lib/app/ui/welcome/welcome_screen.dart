import 'package:royaldusk_mobile_app/widgets/custom_button_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../controller/welcome_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  late WelcomeController controller;

  @override
  void initState() {
    super.initState();
    controller = WelcomeController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
        init: controller,
        tag: 'travel_welcome',
        // theme: theme,
        builder: (controller) {
          return Material(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(welcomeBg), fit: BoxFit.cover)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // 20.height,
                            Text(welcomeText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                  fontSize: textSizeXLarge,
                                  fontWeight: FontWeight.w700,
                                  color: appTextColorPrimary
                                )),
                            20.height,
                            Text(welcomeDesc,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: textSizeMedium,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        appTextColorPrimary.withAlpha(153))),
                            35.height,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: CustomButtonWithIcon(
                                    icon: smsIcon,
                                    onPressed: () {
                                      controller.goToSignInScreen();
                                    },
                                    text: continueWithEmail,
                                  )),
                            ),
                            20.height,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: CustomButtonWithIcon(
                                  icon: facebookIcon,
                                  onPressed: () {},
                                  text: continueWithFacebook,
                                ),
                              ),
                            ),
                            20.height,
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: CustomButtonWithIcon(
                                  icon: googleIcon,
                                  onPressed: () {},
                                  text: continueWithGoogle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
