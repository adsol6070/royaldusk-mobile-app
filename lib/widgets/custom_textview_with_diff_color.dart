import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';

class CustomTextViewWithStyle extends StatelessWidget {
  final String text1;
  final String text2;
  final bool isDarkMode;
  final FontWeight? fontWeight;
  final double? fontSize;


  const CustomTextViewWithStyle({super.key, required this.text1, required this.text2,
    required this.isDarkMode, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          style:  TextStyle(
              fontSize:fontSize ?? 14.0,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: appColorPrimary), // Adjust the font size as needed
        ),
        Text(
          text2,
          style: TextStyle(
              fontSize:fontSize ?? 14.0,
              fontWeight: fontWeight ?? FontWeight.w400,
              color:isDarkMode
                  ? whiteColor.withAlpha(153)
                  :  appTextColorPrimary
                  .withAlpha(153)), // Adjust the font size as needed
        ),
      ],
    );
  }
}
