import 'package:royaldusk_mobile_app/widgets/custom_button_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../controller/signin_controller.dart';
import '../../controller/welcome_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  late WelcomeController controller;
  late SignInController signIncontroller;

  @override
  void initState() {
    super.initState();
    controller = WelcomeController();
  }

  @override
  Widget build(BuildContext context) {
    signIncontroller = Get.put(SignInController(context));
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
                            // 20.height,
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 60,
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 12),
                            //     child: CustomButtonWithIcon(
                            //       icon: facebookIcon,
                            //       onPressed: () {},
                            //       text: continueWithFacebook,
                            //     ),
                            //   ),
                            // ),
                            20.height,
  SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: ElevatedButton(
                                onPressed: signIncontroller.isAnyLoading
                                    ? null
                                    : () => signIncontroller.signInWithGoogle(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: whiteColor,
                                  foregroundColor: appTextColorPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                      color: borderColor.withAlpha(31),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: signIncontroller.isAnyLoading
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                appTextColorPrimary,
                                              ),
                                            ),
                                          ),
                                          12.width,
                                          Text(
                                            'Signing in with Google...',
                                            style: TextStyle(
                                              color: appTextColorPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            googleIcon,
                                            height: 20,
                                            width: 20,
                                          ),
                                          12.width,
                                          Text(
                                            continueWithGoogle,
                                            style: TextStyle(
                                              color: appTextColorPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
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
      },
    );
  }
}

