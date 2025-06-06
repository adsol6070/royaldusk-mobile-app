import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';

class CustomTextViewWithIcon extends StatelessWidget {
  final String text;
  final String icon;
  final bool isDarkMode;
  final FontWeight? fontWeight;
  final double? fontSize;

  const CustomTextViewWithIcon(
      {super.key,
      required this.text,
      required this.icon,
      required this.isDarkMode,
      this.fontWeight,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16,
          height: 16,
        ),
        3.width,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: fontSize ?? 14.0,
                fontWeight: fontWeight ?? FontWeight.w400,
                color: isDarkMode
                    ? whiteColor.withAlpha(153)
                    : appTextColorPrimary
                        .withAlpha(153)), // Adjust the font size as needed
          ),
        ),
      ],
    );
  }
}
