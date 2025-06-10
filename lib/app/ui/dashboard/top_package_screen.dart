import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/strings.dart';
import '../../../widgets/custom_textview_with_diff_color.dart';
import '../../model/popular_packages.dart';

class TopPackagesScreen extends StatefulWidget {
  final PopularPackage popularPackage;
  final bool isDarkMode;

  const TopPackagesScreen(this.popularPackage, this.isDarkMode, {super.key});

  @override
  TopPackagesScreenState createState() => TopPackagesScreenState();
}

class TopPackagesScreenState extends State<TopPackagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: commonCacheImageWidget(
                    widget.popularPackage.imageUrl.toString(), 80),
              ),
            ),
            8.width,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.popularPackage.name.toString(),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: textSizeMedium, fontWeight: FontWeight.bold),
                  ),
                  5.height,
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        mapIcon,
                        height: 12,
                        width: 12,
                      ),
                      5.width,
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.popularPackage.location.toString(),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: primaryTextStyle(
                              size: 14,
                              color: widget.isDarkMode
                                  ? whiteColor.withAlpha(153)
                                  : appTextColorPrimary.withAlpha(153)),
                        ),
                      ),
                      6.width,
                      Container(
                        width: 5.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isDarkMode
                                ? whiteColor.withAlpha(64)
                                : appTextColorPrimary.withAlpha(64)),
                      ),
                      6.width,
                      CustomTextViewWithStyle(
                        text1: widget.popularPackage.price.toString(),
                        text2: night,
                        isDarkMode: widget.isDarkMode,
                      )
                    ],
                  ),
                  5.height,
                  Row(children: [
                    SvgPicture.asset(
                      starIcon,
                      height: 12,
                      width: 12,
                    ),
                    5.width,
                    const Text(
                      "4.5",
                      style: TextStyle(
                        fontSize: textSizeSmall,
                      ),
                    ),
                    5.width,
                    Text(
                      "(${widget.popularPackage.review})",
                      style: TextStyle(
                          fontSize: textSizeSmall,
                          color: widget.isDarkMode
                              ? whiteColor.withAlpha(153)
                              : appTextColorPrimary.withAlpha(153)),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
