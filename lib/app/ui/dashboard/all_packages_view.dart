import 'package:royaldusk_mobile_app/app/model/popular_packages.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/custom_textview_with_diff_color.dart';
import 'package:royaldusk_mobile_app/widgets/custom_textview_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../../widgets/rounded_imageview.dart';

class AllPackagesViewScreenState extends StatefulWidget {
  final PopularPackage package;
  final bool isDarkMode;

  const AllPackagesViewScreenState(
      {super.key, required this.package, required this.isDarkMode});

  @override
  PackagesViewState createState() => PackagesViewState();
}

class PackagesViewState extends State<AllPackagesViewScreenState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 230,
          height: 240,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      RoundedImageView(
                        imageUrl: widget.package.image.toString(),
                        radius: 16.0,
                        height: 152,
                        width:
                            194, // Adjust the radius to control the roundness
                      )
                    ],
                  ),
                  8.height,
                  Text(
                    widget.package.name.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: textSizeMedium, fontWeight: FontWeight.bold),
                  ),
                  5.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextViewWithIcon(
                            text: widget.package.location.toString(),
                            icon: mapIcon,
                            isDarkMode: widget.isDarkMode),
                      ),
                      CustomTextViewWithStyle(
                          text1: widget.package.price.toString(),
                          text2: night,
                          isDarkMode: widget.isDarkMode)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
