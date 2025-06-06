import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../widgets/app_layout.dart';
import '../../../widgets/circle_container.dart';
import '../../../widgets/glass_effect.dart';
import '../../../widgets/my_separator.dart';
import '../../../widgets/ticket_clipper.dart';
import '../../model/ticket.dart';
import '../flight/boarding_pass_screen.dart';


class TripFlightTicketView extends StatelessWidget {
  final Ticket ticket;
  final bool? isColor;
  final double? rightMargin;
  final bool isDarkMode;

  const TripFlightTicketView(
      {super.key,
      required this.ticket,
      this.isColor,
      this.rightMargin,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return GestureDetector(
      onTap: (){
        Get.to( const BoardingPassScreen());
      },
      child: SizedBox(
        width: size.width * 0.90,
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
          margin: EdgeInsets.only(right: rightMargin ?? 12, top: 15),
          child: Column(
            children: [
              GlassEffect(
                topLeft: 24,
                topRight: 24,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? cardBackgroundBlackDark : whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            ticket.from!.code.toString(),
                            style: const TextStyle(
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
                                      : appTextColorPrimary.withAlpha(204))),
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
                                      : appTextColorPrimary.withAlpha(204))),
                          5.width,
                          const CircleContainer(
                            color: purpleColor,
                          ),
                          10.width,
                          Text(
                            ticket.to!.code.toString(),
                            style: const TextStyle(
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
                                ticket.from!.name.toString(),
                                style: TextStyle(
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153),
                                  fontSize: textSizeSMedium,
                                ),
                              )),
                          Text(
                            ticket.duration.toString(),
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: textSizeSMedium,
                                color: isDarkMode
                                    ? whiteColor
                                    : appTextColorPrimary
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              ticket.to!.name.toString(),
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
                                ticket.flyingTime.toString(),
                                style:  TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary,
                                    fontSize: textSizeMedium,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 100,
                            child: Text(
                              ticket.departureTime.toString(),
                              textAlign: TextAlign.end,
                              style:  TextStyle(
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
                            ticket.flyingDate.toString(),
                            style: TextStyle(
                              fontSize: textSizeSMedium,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? whiteColor.withAlpha(153)
                                  : appTextColorPrimary.withAlpha(153),
                            ),
                          ),
                          Text(
                            ticket.departureDate.toString(),
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
                    color: isDarkMode ? cardBackgroundBlackDark : Colors.white,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
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
                    padding: const EdgeInsets.all(15),
                    color: isDarkMode ? cardBackgroundBlackDark : Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              child: commonCacheImageWidget(ticket.logoUrl, 36,
                                  width: 36),
                            ),
                            10.width,
                            Expanded(
                              child: Text(
                                ticket.airlinesName.toString(),
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(
                                  color: isDarkMode
                                      ? whiteColor
                                      : appTextColorPrimary,
                                  fontSize: textSizeMedium,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '\$${ticket.price}',
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                color: isDarkMode
                                    ? whiteColor
                                    : appTextColorPrimary,
                                fontSize: textSizeLargeMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
