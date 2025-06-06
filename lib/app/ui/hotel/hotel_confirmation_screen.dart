import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/custom_row_text_with_click.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../route/my_route.dart';
import '../../controller/hotel_confirmation_controller.dart';


class HotelConfirmationScreen extends StatefulWidget {

  const HotelConfirmationScreen({Key? key})
      : super(key: key);

  @override
  HotelConfirmationScreenState createState() => HotelConfirmationScreenState();
}

class HotelConfirmationScreenState extends State<HotelConfirmationScreen> {
  late HotelConfirmationController controller;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = HotelConfirmationController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HotelConfirmationController>(
        init: controller,
        tag: 'travel_hotel_confirmation',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            backgroundColor: isDarkMode ? appDarkBgColor : whiteColor,
            appBar: commonAppBarWidget(context, titleText: confirmation),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        yourHotel,
                        style: TextStyle(
                            fontSize: textSizeLargeMedium,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.ubuntu().fontFamily),
                      ),
                      20.height,
                      CustomRowTextWithClick(
                          title: dateTitle,
                          onPressed: () {},
                          isDarkMode: isDarkMode),
                      5.height,
                      _buildText('07-10 June, 2023'),
                      20.height,
                      CustomRowTextWithClick(
                          title: hotelText,
                          onPressed: () {},
                          isDarkMode: isDarkMode),
                      5.height,
                      _buildText('The Enchanted Garden'),
                      20.height,
                      CustomRowTextWithClick(
                          title: arrangements,
                          onPressed: () {},
                          isDarkMode: isDarkMode),
                      5.height,
                      _buildText('2 Bedroom, Food, Gym, and More'),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                personTitle,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153),
                                  fontSize: textSizeMedium,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              _buildText('02 Persons'),
                            ],
                          ),
                          // Flexible(fit: FlexFit.tight, child: SizedBox()),
                          _buildQtyPicker()
                        ],
                      ),
                      10.height,
                      Row(
                        children: [
                          SvgPicture.asset(
                            infoCircleIcon,
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? whiteColor.withAlpha(153)
                                    : appTextColorPrimary.withAlpha(153),
                                BlendMode.srcIn),
                          ),
                          5.width,
                          Text(
                            'Every person you add it will be \$520',
                            style: TextStyle(
                                color: isDarkMode
                                    ? whiteColor.withAlpha(153)
                                    : appTextColorPrimary.withAlpha(153),
                                fontWeight: FontWeight.w500,
                                fontSize: textSizeSmall),
                          )
                        ],
                      ),
                      10.height,
                      Divider(
                        color: isDarkMode
                            ? whiteColor.withAlpha(26)
                            : appTextColorPrimary.withAlpha(26),
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            total,
                            style: TextStyle(
                              color: isDarkMode
                                  ? whiteColor.withAlpha(153)
                                  : appTextColorPrimary.withAlpha(153),
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('\$1,040',
                              style: TextStyle(
                                  fontSize: textSizeNormal,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily))
                        ],
                      ),
                      30.height,
                      GradientElevatedButton(
                          onPressed: () {
                            Get.offNamed(MyRoutes.paymentScreen);
                          },
                          text: continueText),

                      20.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildQtyPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => controller.decrement(),
          child: SvgPicture.asset(
            isDarkMode ? minusWhiteIcon : minusIcon,
            width: 24,
            height: 24,
          ),
        ),
        10.width,
        Obx(
              () => Text(
            '${controller.quantity}',
            style: const TextStyle(
                fontSize: textSizeNormal, fontWeight: FontWeight.bold),
          ),
        ),
        10.width,
        GestureDetector(
          onTap: () => controller.increment(),
          child: SvgPicture.asset(
            isDarkMode ? addWhiteIcon : addIcon,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  _buildText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: textSizeMedium,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.ubuntu().fontFamily));
  }
}
