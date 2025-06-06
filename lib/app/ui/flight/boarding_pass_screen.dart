
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_layout.dart';
import '../../../widgets/circle_container.dart';
import '../../../widgets/glass_effect.dart';
import '../../../widgets/grediant_button.dart';
import '../../../widgets/my_separator.dart';
import '../../../widgets/ticket_clipper.dart';
import '../../controller/boarding_pass_controller.dart';

class BoardingPassScreen extends StatefulWidget {
  const BoardingPassScreen({super.key});

  @override
  BoardingPassScreenState createState() => BoardingPassScreenState();
}

class BoardingPassScreenState extends State<BoardingPassScreen> {
  late bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final BoardingPassController controller = Get.put(BoardingPassController());
    isDarkMode = controller.themeController.isDarkMode;

    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
      appBar: commonAppBarWidget(context, titleText: boardingPass),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: appColorPrimary.withAlpha(51)),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(15),
            width: size.width,
            // height: 200,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: appTextColorPrimary.withAlpha(77),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              // color: isDarkMode ? appBackgroundColorDark :appLightBgColor,
              // margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  GlassEffect(
                    topLeft: 24,
                    topRight: 24,
                    child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? cardBackgroundBlackDark : whiteColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: commonCacheImageWidget(
                                'https://i.ibb.co/wLFpy2R/Ellipse.png',
                                45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            10.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'MD Rafi Islam',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: textSizeMedium,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Passenger',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? whiteColor.withAlpha(153)
                                          : appTextColorPrimary
                                              .withAlpha(153),
                                      fontSize: textSizeSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ClipOval(
                              child: commonCacheImageWidget(
                                'https://i.ibb.co/MS24gC4/Ellipse.png',
                                45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )),
                  ),
                  ClipPath(
                    clipper: TicketClipper(holeRadius: 24, bottom: 0),
                    child: GlassEffect(
                      child: Container(
                        height: 24,
                        color:
                            isDarkMode ? cardBackgroundBlackDark : Colors.white,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  (constraints.constrainWidth() / 15).floor(),
                                  (index) => SizedBox(
                                      width: 6,
                                      height: 1,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? whiteColor.withAlpha(204)
                                                : appTextColorPrimary
                                                    .withAlpha(204)),
                                      ))),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GlassEffect(
                    // topLeft: 24,
                    // topRight: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? cardBackgroundBlackDark : whiteColor,
                        borderRadius: const BorderRadius.only(
                            // topLeft: Radius.circular(24),
                            // topRight: Radius.circular(24),
                            ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "NYC",
                                style: TextStyle(
                                    color: darkYellow,
                                    fontSize: textSizeMedium,
                                    fontWeight: FontWeight.bold),
                              ),
                              10.width,
                              const CircleContainer(),
                              5.width,
                              Expanded(
                                  flex: 1,
                                  child: MySeparator(
                                      height: 2,
                                      color: isDarkMode
                                          ? whiteColor.withAlpha(204)
                                          : appTextColorPrimary
                                              .withAlpha(204))),
                              5.width,
                              Center(
                                child: SvgPicture.asset(
                                  ticketAirplaneIcon,
                                  // color: Colors.white,
                                  width: 24, height: 24,
                                ),
                              ),
                              5.width,
                              Expanded(
                                  flex: 1,
                                  child: MySeparator(
                                      height: 1,
                                      color: isDarkMode
                                          ? whiteColor.withAlpha(204)
                                          : appTextColorPrimary
                                              .withAlpha(204))),
                              5.width,
                              const CircleContainer(
                                color: purpleColor,
                              ),
                              10.width,
                              const Text(
                                "SIN",
                                style: TextStyle(
                                    color: purpleColor,
                                    fontSize: textSizeMedium,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          4.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                    "New York",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? whiteColor.withAlpha(153)
                                          : appTextColorPrimary
                                              .withAlpha(153),
                                      fontSize: textSizeSMedium,
                                    ),
                                  )),
                              Text(
                                "06h 30m",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSizeSMedium,
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "Singapore",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor.withAlpha(153)
                                        : appTextColorPrimary.withAlpha(153),
                                    fontSize: textSizeSMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          15.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                    "19:00",
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? whiteColor
                                            : appTextColorPrimary,
                                        fontSize: textSizeMedium,
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "01:30",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? whiteColor
                                          : appTextColorPrimary,
                                      fontSize: textSizeMedium,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          4.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "June 07, 2023",
                                style: TextStyle(
                                  fontSize: textSizeSMedium,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153),
                                ),
                              ),
                              Text(
                                "June 08, 2023",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: textSizeSMedium,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: TicketClipper(holeRadius: 24, bottom: 0),
                    child: GlassEffect(
                      child: Container(
                        height: 24,
                        color:
                            isDarkMode ? cardBackgroundBlackDark : Colors.white,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  (constraints.constrainWidth() / 15).floor(),
                                  (index) => SizedBox(
                                      width: 6,
                                      height: 1,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? whiteColor.withAlpha(204)
                                                : appTextColorPrimary
                                                    .withAlpha(204)),
                                      ))),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GlassEffect(
                      bottomLeft: 24,
                      bottomRight: 24,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        color:
                            isDarkMode ? cardBackgroundBlackDark : Colors.white,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Scan this barcode!',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDarkMode
                                    ? whiteColor.withAlpha(153)
                                    : appTextColorPrimary.withAlpha(153),
                                fontSize: textSizeSMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            10.height,
                            Image.asset(
                              barcodeImage,
                              width: 200,
                              color:
                                  isDarkMode ? whiteColor : appTextColorPrimary,
                            ),
                            10.height,
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        height: 100,
        child: GradientElevatedButton(
            onPressed: () {
              Get.back();
            },
            text: downloadTicket
            // ,height: 70,
            ),
      ),
    );
  }
}
