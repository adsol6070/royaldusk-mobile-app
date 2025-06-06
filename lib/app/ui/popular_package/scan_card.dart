import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../controller/scan_card_controller.dart';



class ScanCardScreen extends StatefulWidget {
  const ScanCardScreen({Key? key}) : super(key: key);

  @override
  ScanCardScreenState createState() => ScanCardScreenState();
}

class ScanCardScreenState extends State<ScanCardScreen> {
  late ScanCardController controller;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = ScanCardController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanCardController>(
        init: controller,
        tag: 'travel_scan_card',
        // theme: theme,
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: isDarkMode ? appDarkBgColor : whiteColor,
              appBar: commonAppBarWidget(context, titleText: scanCard),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      cardDesc,
                      style: TextStyle(
                          color: isDarkMode
                              ? whiteColor.withAlpha(153)
                              : appTextColorPrimary.withAlpha(153)),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Image.asset(creditCardImage),
                            onPressed: () async {
                              controller.scanCard();
                            },
                          ),
                          if (controller.cardDetails != null)
                            Text(controller.cardDetails.toString()),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: GradientElevatedButton(
                          onPressed: () {},
                          text: confirmText,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
